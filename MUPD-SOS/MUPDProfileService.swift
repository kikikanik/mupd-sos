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
    
    let fsCollection = Firestore.firestore().collection("mupdprofile")  //initializing "profile" collection in Firestore
    
    var MUPDProfiles: [MUPDProfile] = []
    
    var currentUser: User!
    var currentProfile: MUPDProfile!
    
    private init () {
        
    }
    
    func addMUPDProfile(MUPDProfiles: MUPDProfile, docID: String) {
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
        
        var mupdprofile: MUPDProfile?
        let docRef = fsCollection.document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let aMUPDProfile = MUPDProfile(data: document.data()!, documentID: document.documentID) {
                    mupdprofile = aMUPDProfile
                    print ("DOCUMENT/PROFILE ALREADY EXISTS!: \(document)")
                    completionHandler(true, mupdprofile)
                }
            }
            else {
                print ("DOCUMENT/PROFILE DOES NOT EXIST!!!")
                completionHandler(false, mupdprofile)
            }
        }
    }
    
    func addMUPDProfileInfo(currentUser: MUPDProfile) {
        let uid = userService.currentUser!.documentID!
        print ("UNIQUE IDENTIFIER OF USER: \(uid)")
        self.addMUPDProfile(MUPDProfiles: currentUser, docID: uid)
    }
    
    func updateOnDuty(currentProfile: MUPDProfile) {
        let uid = currentProfile.userID
        print("UNIQUE IDENTIFIER OF USER: \(uid)")
        
        fsCollection.document(uid).updateData([
            "onDuty": currentProfile.onDuty
        ])
        
        print("DOCUMENT \(uid) on duty WAS UPDATED IN FIRESTORE!!")
    }
    
    //func here to get all the notifications from firestore
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
