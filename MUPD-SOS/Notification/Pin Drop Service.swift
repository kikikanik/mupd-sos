//
//  PinDropService.swift
//  MapDemo4Lak
//
//  Created by Kinneret Kanik on 08/02/2023.
//

import Foundation
import FirebaseFirestore
import Firebase
import UIKit
import CoreLocation

class PinDropService {

    static let shared = PinDropService()    //NOT SURE IF WE NEED THIS???
    
    let userService = UserService.shared
    
    let fsCollection = Firestore.firestore().collection("notification")
    var sosNotifications: [PinDrop] = []
    var currentUser: User?
        
    private init () {
        
    }
    
    // Adding notification type/name from 'EmergencyTabViewController'
    func addNotifName(pinDrop: PinDrop) {
        fsCollection.addDocument(data: pinDrop.createPinDropDict())
    }
    
    // Adding a NEW pin drop with NEW documentID
    func addNotification(pinDrop: PinDrop) {
        //sosUser: User, docID: String
        fsCollection.addDocument(data: pinDrop.createPinDropDict()) //sending Pin Drop attributes from object to Firestore
        
    }
    
    //func here to get all the notifications from firestore
    func observeNotifications () {
        
        fsCollection.addSnapshotListener { (querySnapshot, err) in
           
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.sosNotifications = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                   
                    if let aNotification = PinDrop(data: document.data(), documentID: document.documentID) {
                        self.sosNotifications.append(aNotification)
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue:  kSOSNotificaionsChanged), object: self)
            }
        }
       
    }

}
    
    

    
   




