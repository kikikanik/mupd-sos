//
//  User Service.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class UserService {
    
    static let shared = UserService()   //declared share of UserService to other files
    
    let auth = Auth.auth()  //initializing Firebase Authenticator
    
    let fsCollection = Firestore.firestore().collection("user") //initializing "user" collection in Firestore
    
    var mupdUsers: [User] = []
    var currentUser: User?
    
    private init () {
        
    }
    
    func addUser(mupdUser: User, docID: String) {
        
        fsCollection.document(docID).setData(mupdUser.asDictionary()) { err in
            if let err = err {
                print ("ERROR ADDING THIS DOCUMENT!! \(err)")
            }
            else {
                print ("DOCUMENT ADDED WITH THIS DOCUMENT ID: \(docID)")
            }
        }
    }
    
    
    func findUser(withID id: String, completionHandler: @escaping (Bool, User?) -> Void) {
        
        var user: User?
        let docRef = fsCollection.document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let anUser = User(data: document.data()!, documentID: document.documentID) {
                    user = anUser
                    print ("DOCUMENT/USER EXISTS!: \(document)")
                    completionHandler(true, user)
                }
            }
            else {
                print ("DOCUMENT/USER DOES NOT EXIST!!!")
                completionHandler(false, user)
            }
        }
    }

    //Firebase Authentication Methods
    /*
    func registerUser(id: String, officerTitle: String, officerFullName: String, email: String, password: String, anUser: User, completionHandler: @escaping (Bool) -> Void) {
        print ("New Registered User: \(email) \(password)")  //print email and password of registered User in console!
     */
    func registerUser(email: String, password: String, currentUser: User, completionHandler: @escaping (Bool) -> Void) {
        print ("New Registered User: \(email) \(password)")  //print email and password of registered User in console!
        
        
        auth.createUser(withEmail: email, password: password) {[weak self]
            authResult, error in
            guard authResult != nil, error == nil else {
                print (error)
                print ("REGISTRATION FAILED!")
                completionHandler(false)
                return
            }
            print ("REGISTRATION SUCCESSFUL!!")
            let uid = authResult!.user.uid
            print ("UNIQUE IDENTIFIER OF USER: \(uid)")
            self?.addUser(mupdUser: currentUser, docID: uid)
            completionHandler(true)
            
            
            //get current User information!
          //  authResult!.user.uid
            print ("UNIQUE IDENTIFIER FOR RETURNING USER: \(uid) WITH EMAIL \(email)")
            
            self?.findUser(withID: uid) {(result, currentUser) in
                if result {
                    self?.currentUser = currentUser
                    completionHandler(true)
                }
                else {
                    completionHandler(false)
                }
            }
        }
    }
    
    
    func signIn(email: String, password: String, currentUser: User, completionHandler: @escaping (Bool) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { [weak self]
            authResult, error in
            guard authResult != nil, error == nil else {
                completionHandler(false)
                return
            }
            
            //get current User information!
            let uid = authResult!.user.uid
            print ("UNIQUE IDENTIFIER FOR RETURNING USER: \(uid) WITH EMAIL \(email)")
            
            self?.findUser(withID: uid) {(result, currentUser) in
                if result {
                    self?.currentUser = currentUser
                    completionHandler(true)
                }
                else {
                    completionHandler(false)
                }
            }
        }
    }
}
