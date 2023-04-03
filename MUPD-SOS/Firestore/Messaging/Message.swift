//
//  Chat.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 27/03/2023.
//
import Foundation
import Firebase
import FirebaseFirestore

struct Message {
    var messageID: String
    var postedBy: String
    var postedMessage: String
    
    init(messageID: String, postedBy: String, postedMessage: String) {
        self.messageID = messageID
        self.postedBy = postedBy
        self.postedMessage = postedMessage
    }

    init?(data: [String: Any], documentID: String) {
        guard let messageID = documentID as String?,
              let postedBy = data["postedBy"] as? String,
              let postedMessage = data["postedMessage"] as? String else {
            return nil
        }
        self.messageID = messageID
        self.postedBy = postedBy
        self.postedMessage = postedMessage
    }
    
    func createMessageDict() -> [String: Any]{
        let dict: [String: Any] = [
            "messageID": self.messageID,
            "postedBy": self.postedBy,
            "postedMessage": self.postedMessage
        ]
        return dict
    }
}
