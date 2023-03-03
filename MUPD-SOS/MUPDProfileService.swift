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
    
    var MUPDprofile: [MUPDProfile] = []
    var existingMUPDProfile: MUPDProfile?
    
    var currentUser: User!
    
    private init () {
        
    }
    
    func addMUPDProfile(MUPDprofile: MUPDProfile, docID: String) {
        fsCollection.document(docID).setData(MUPDprofile.createMUPDProfileDict()) {
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
        self.addMUPDProfile(MUPDprofile: currentUser, docID: uid)
    }
}
