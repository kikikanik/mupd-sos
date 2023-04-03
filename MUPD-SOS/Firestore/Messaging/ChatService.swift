//
//  ChatService.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 27/03/2023.
//

import Foundation
import FirebaseFirestore

class ChatService {

    static let shared = ChatService()
    
    let pinDropService = PinDropService.shared
    let userService = UserService.shared
    
    var existingMessages: Message!
    var chat: [Message] = []

    let nc = NotificationCenter.default
    
    let fsCollection = Firestore.firestore().collection("notification")

    private init () {

    }
    
    // Adding a NEW pin drop with NEW documentID
    func addMessage(message: Message, notificationID: String) {
        fsCollection.document(notificationID).collection("chat").addDocument(data: message.createMessageDict())
    }
    
    func addMessageMaybe(message: Message, notificationID: String, docID: String) {
       // fsCollection.document(notificationID).collection("chat").addDocument(data: message.createMessageDict()) {
        fsCollection.document(notificationID).collection("chat").document(docID).setData(message.createMessageDict()) {

       // fsCollection.document(docID).setData(message.createMessageDict()) {
            err in
            if let err = err {
                print ("ERROR ADDING THE Message DOCUMENT!! \(err)")
            }
            else {
                print ("DOCUMENT ADDED WITH Message DOC ID: \(docID)")
            }
        }
    }
    /*
     func addReport(report: Report, docID: String) {
         fsCollection.document(docID).setData(report.createReportDict()) {
             err in
             if let err = err {
                 print ("ERROR ADDING THE Report DOCUMENT!! \(err)")
             }
             else {
                 print ("DOCUMENT ADDED WITH Report DOC ID: \(docID)")
             }
         }
     }
     */
    
    //func here to get all the notifications from firestore
    func observeChat(notificationID: String) {
        
        fsCollection.document(notificationID).collection("chat").addSnapshotListener { (querySnapshot, err) in
           
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.chat = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                   
                    if let aChat = Message(data: document.data(), documentID: document.documentID) {
                        self.chat.append(aChat)
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue:  kSOSMessagesChanged), object: self)
            }
        }
       
    }

}
