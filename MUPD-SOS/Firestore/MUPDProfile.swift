//
//  Profile.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 01/03/2023.
//

import Foundation

struct MUPDProfile: Codable {
    //var documentID: String?
    var userID: String    //using this id to connect to id under User object
    var title: String
    var fullName: String
    var badge: String
    var onDuty: String
    
    init(userID: String, title: String, fullName: String, badge: String, onDuty: String) {
        //constructs the Profile Object
        self.userID = userID
        self.title = title
        self.fullName = fullName
        self.badge = badge
        self.onDuty = onDuty
    }
    
    init?(data: [String: Any], documentID: String) {
        guard let userID = data["userID"] as? String,
              let title = data["title"] as? String,
              let fullName = data["fullName"] as? String,
              let badge = data["badge"] as? String,
              let onDuty = data["onDuty"] as? String else {
            return nil
        }
        self.userID = userID
        self.title = title
        self.fullName = fullName
        self.badge = badge
        self.onDuty = onDuty
    }
    
    
    func createMUPDProfileDict() -> [String: Any] {
        return ["userID": self.userID,
                "title": self.title,
                "badge": self.badge,
                "fullName": self.fullName,
                "onDuty": self.onDuty
        ]
    }
}
