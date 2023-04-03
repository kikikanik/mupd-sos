//
//  User.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation

struct User: Identifiable, Codable {            //creating the User Object
    var documentID: String?
    var id: String
    var email: String
    var tac: Bool
    var userType: String
  //  var username: String
    
    
   init(id: String, email: String, tac: Bool, userType: String) {    //constructs the User Object
        self.id = id
        self.email = email
        self.tac = tac
        self.userType = userType
    }
    
    init?(data: [String: Any], documentID: String) {
        guard let id = data["id"] as? String,
              let email = data["email"] as? String,
              let tac = data["tac"] as? Bool,
              let userType = data["userType"] as? String else {
            return nil
        }
        self.documentID = documentID
        self.id = id
        self.email = email
        self.tac = tac
        self.userType = userType
        
    }
    
  
    
    func asDictionary() -> [String: Any] {
        return ["id": self.id,
                "email": self.email,
                "tac": self.tac,
                "userType": self.userType
        ]
    }
}
