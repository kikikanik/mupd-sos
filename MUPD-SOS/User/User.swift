//
//  User.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    //creating the User Object
    var documentID: String?
    var id: String
    var officerTitle: String
    var officerFullName: String
    var email: String
    
    init(id: String, officerTitle: String, officerFullName: String, email:String) {    //constructs the User Object
        self.id = id
        self.officerTitle = officerTitle
        self.officerFullName = officerFullName
        self.email = email
    }
    
    init?(data: [String: Any], documentID: String) {
        guard let id = data["id"] as? String,
              let officerTitle = data["officerTitle"] as? String,
              let officerFullName = data["officerFullName"] as? String,
              let email = data["email"] as? String else {
            return nil
        }
        self.documentID = documentID
        self.id = id
        self.officerTitle = officerTitle
        self.officerFullName = officerFullName
        self.email = email
    }
    
    func asDictionary() -> [String: Any] {
        return ["id": self.id,
                "officerTitle": self.officerTitle,
                "officerFullName": self.officerFullName,
                "email": self.email
        ]
    }
}
