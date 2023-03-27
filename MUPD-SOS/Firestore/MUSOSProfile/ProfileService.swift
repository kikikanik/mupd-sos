//
//  ProfileService.swift
//  MU-SOSMainApp
//
//

import Foundation
import FirebaseFirestore
import Firebase


class ProfileService {
    static let shared = ProfileService()
    
    let userService = UserService.shared
    
    let fsCollection = Firestore.firestore().collection("profile")  //initializing "profile" collection in Firestore
    
    var profile: [Profile] = []
    var existingProfile: Profile!
    
    var currentUser: User!
    
    private init () {
        
    }
    
    func addProfile(profile: Profile, docID: String) {
        fsCollection.document(docID).setData(profile.createProfileDict()) {
            err in
            if let err = err {
                print ("ERROR ADDING THE PROFILE DOCUMENT!! \(err)")
            }
            else {
                print ("DOCUMENT ADDED WITH PROFILE DOC ID: \(docID)")
            }
        }
    }
    
    func findProfile(withID id: String, completionHandler: @escaping (Bool, Profile?) -> Void) {
        
        var profile: Profile?
        let docRef = fsCollection.document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let aProfile = Profile(data: document.data()!, documentID: document.documentID) {
                    profile = aProfile
                    print ("DOCUMENT/PROFILE ALREADY EXISTS!: \(document)")
                    completionHandler(true, profile)
                }
            }
            else {
                print ("DOCUMENT/PROFILE DOES NOT EXIST!!!")
                completionHandler(false, profile)
            }
        }
    }
        
    func addProfileInfo(currentUser: Profile, completionHandler: @escaping (Bool) -> Void) {
       
        let uid = userService.currentUser!.documentID!
        
        self.findProfile(withID: uid) {(result, existingProfile) in
            if result {
                self.existingProfile = existingProfile
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        }
        print ("UNIQUE IDENTIFIER OF USER: \(uid)")
        self.addProfile(profile: currentUser, docID: uid)
    }
    
  /*
    func getProfile(userID: String, completionHandler: @escaping (Bool) -> Void) {
        let userID = existingProfile.userID
        
        self.findProfile(withID: userID) {(result, existingProfile) in
            if result {
                self.existingProfile = existingProfile
                self.fsCollection.document(userID).getDocument {
                    (document, error) in
                    print("GETTING THIS DOCUMENT WITH ID: \(userID)")
                    print("HERE IS THE PROFILE INFO!: \(existingProfile)")
                    completionHandler(true)
                }
            }
            else {
                print("NO DOCUMENT TO GRAB!")
                completionHandler(false)
            }
            
        }
        
    }
   */
    
    func getProfileInfo(profile: Profile) {
        let uid = userService.currentUser!.documentID!
        print("UNIQUE IDENTIFIER OF USER: \(uid)")
    }
    
    func observeProfile(currentUser: Profile, completionHandler: @escaping (Bool) -> Void) {
        
        let uid = userService.currentUser!.documentID!
        
        fsCollection.addSnapshotListener { [self]
            (querySnapshot, err) in
            profile.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    self.findProfile(withID: uid) {(result, existingProfile) in
                        if result {
                            self.existingProfile = existingProfile
                            completionHandler(true)
                        }
                        else {
                            completionHandler(false)
                        }
                    }
                    
                        self.profile.append(existingProfile!)
                        print("PROFILES GRABBED \(existingProfile)")
                        print(profile)

                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: kSOSProfilesChanged), object: self)
            }
            
        }
    }
    
}
