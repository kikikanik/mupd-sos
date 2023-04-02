//
//  MUPDProfileService.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 01/03/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class MUPDProfileService {
    
    static let shared = MUPDProfileService()
    
    let userService = UserService.shared
    
    let fsCollection = Firestore.firestore().collection("mupdprofile")
    
    var MUPDProfiles: [MUPDProfile] = []
    var existingMUPDProfile: MUPDProfile!
    
    var currentUser: User!
    
    private init () {
        
    }
    
    func addMUPDProfile(MUPDProfiles: MUPDProfile, docID: String) {
        var docID = userService.currentUser!.email
        
        fsCollection.document(docID).setData(MUPDProfiles.createMUPDProfileDict()) {
            err in
            if let err = err {
                print ("ERROR ADDING THE MUPD PROFILE DOCUMENT!! \(err)")
            }
            else {
                print ("DOCUMENT ADDED WITH MUPD PROFILE DOC ID: \(docID)")
            }
        }
    }
    
    func findMUPDProfile(withID id: String, completionHandler: @escaping (Bool, MUPDProfile?) -> Void) {
        
        var mupdProfile: MUPDProfile?
        let docRef = fsCollection.document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let aProfile = MUPDProfile(data: document.data()!, documentID: document.documentID) {
                    mupdProfile = aProfile
                    print ("DOCUMENT/USER EXISTS!: \(document)")
                    completionHandler(true, mupdProfile)
                }
            }
            else {
                print ("DOCUMENT/USER DOES NOT EXIST!!!")
                completionHandler(false, mupdProfile)
            }
        }
    }

    func addMUPDProfileInfo(currentUser: MUPDProfile, completionHandler: @escaping (Bool) -> Void) {
       
        let uid = userService.currentUser!.documentID!
        
        self.findMUPDProfile(withID: uid) {(result, existingMUPDProfile) in
            if result {
                self.existingMUPDProfile = existingMUPDProfile
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
        print ("UNIQUE IDENTIFIER OF USER: \(uid)")
        self.addMUPDProfile(MUPDProfiles: currentUser, docID: uid)
    }
    
    func getMUPDProfile(docID: String, completionHandler: @escaping (Bool) -> Void) {
        let docID = userService.currentUser!.documentID!
        
        self.findMUPDProfile(withID: docID) {(result, existingMUPDProfile) in
            if result {
                self.existingMUPDProfile = existingMUPDProfile
                self.fsCollection.document(docID).getDocument {
                    
                    (document, error) in
                    print("GETTING THIS DOCUMENT WITH ID: \(docID)")
                    print("HERE IS THE PROFILE INFO!: \(existingMUPDProfile)")
                    
                    completionHandler(true)
                }
            }
            else {
                print("NO DOCUMENT TO GRAB!")
                completionHandler(false)
            }
        }
    }
    
    //func here to get all the notifications from firestore
    //amanda has a diff one - but this one works man 
    func observeMUPDProfiles() {
        
        fsCollection.addSnapshotListener { [self] (querySnapshot, err) in
            MUPDProfiles.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    if let aMUPDProfile = MUPDProfile(data: document.data(), documentID: document.documentID) {
                        print("Success adding mupdprofile to array aMUPDProfile")
                        self.MUPDProfiles.append(aMUPDProfile)
                        print("THESE ARE THE MUPD PROFILES: ")
                        print(MUPDProfiles)
                    } else {
                        print("Error adding mupdprofile to array aMUPDProfile")
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: kSOSMUPDProfilesChanged), object: self)
            }
        }
    }
}
