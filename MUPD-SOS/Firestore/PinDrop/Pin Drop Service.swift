//
//  PinDropService.swift
//  MapDemo4Lak
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
   
    var pinDrop: PinDrop?
    var notifications: [PinDrop] = []
    
   private init () {
       
   }
    
    func updateNotification(pinDrop: PinDrop, docID: String) {
        fsCollection.document(docID).setData(pinDrop.createPinDropDict())
    }

    func getPinDropInfo(forPinDropId id: String) -> PinDrop? {
        if let index = (notifications).firstIndex(where: {$0.pinDropId == id}) {
            print("We got correct pin!")
            return notifications[index]
        }
        return nil;
    }

    func observeNotifications() {
        
        fsCollection.addSnapshotListener { [self] (querySnapshot, err) in
            notifications.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    if let aNotification = PinDrop(data: document.data(), documentID: document.documentID) {
                        print("Success adding notification to array notifications")
                        self.notifications.append(aNotification)
                    } else {
                        print("Error adding reports to array aReports")
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: kSOSNotificationsChanged), object: self)
            }
        }
    }
}
