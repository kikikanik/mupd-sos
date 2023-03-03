//
//  ProfileService.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 28/02/2023.
//
import Foundation
import FirebaseFirestore
import Firebase

class ProfileService {
    static let shared = ProfileService()
    
    let userService = UserService.shared
    
    let fsCollection = Firestore.firestore().collection("profile")  //initializing "profile" collection in Firestore
    
    var profile: [Profile] = []
    var existingProfile: Profile?
    
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
        
    func addProfileInfo(currentUser: Profile) {
        let uid = userService.currentUser!.documentID!
        print ("UNIQUE IDENTIFIER OF USER: \(uid)")
        self.addProfile(profile: currentUser, docID: uid)
    }
}
