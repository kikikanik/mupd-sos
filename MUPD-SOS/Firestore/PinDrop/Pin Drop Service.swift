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

    static let shared = PinDropService()
    
    let userService = UserService.shared
    
    let fsCollection = Firestore.firestore().collection("notification")
    
    //njCountiesNschools
    var notificationsWTypes: [String: [PinDrop]] = ["sosENotifications": [], "sosNENotifications": [],
                                                  "sosMNotifications": []]
    var notifications:[PinDrop] = []
    
    private init () {
        //mapNotificationsToType()
    }
    
    func mapNotificationsToType() {
        let types = Array(notificationsWTypes.keys)
        
        for type in types {
            notificationsWTypes[type] = notifications.filter({($0.notifName).caseInsensitiveCompare(type) == .orderedSame})
            // njCountiesNschools[county] = njSchools.filter({($0.properties.county).caseInsensitiveCompare(county) == .orderedSame})
        }
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
    
    func getPinDropInfo(forPinDropId id: String) -> PinDrop? {
        if let index = (notifications).firstIndex(where: {$0.pinDropId == id}) {
            return notifications[index]
        }
        return nil;
    }
     
    
    //func here to get all the notifications from firestore
    func observeNotifications () {
        
        fsCollection.addSnapshotListener { (querySnapshot, err) in
           
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.notifications = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                   
                    if let aNotification = PinDrop(data: document.data(), documentID: document.documentID) {
                        self.notifications.append(aNotification)
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue:  kSOSNotificaionsChanged), object: self)
            }
        }
       
    }

}
