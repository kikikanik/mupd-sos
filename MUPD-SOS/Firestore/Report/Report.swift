//
//  Report.swift
//  ReportDemo
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Report {
    var reportID: String
    var emergencyType: String
    var message: String
    var postedBy: String
    var timestamp: String
    
    init(reportID: String, emergencyType: String, message: String, postedBy: String, timestamp: String) {
        self.reportID = reportID
        self.emergencyType = emergencyType
        self.message = message
        self.postedBy = postedBy
        self.timestamp = timestamp
    }
    
    init?(data: [String: Any], documentID: String) {
            guard let reportID = documentID as String?,
                  let postedBy = data["postedBy"] as? String,
                  let emergencyType = data["emergencyType"] as? String,
                  let message = data["message"] as? String,
                  let timestamp = data["timestamp"] as? String else {
                return nil
            }
            self.reportID = reportID
            self.postedBy = postedBy
            self.emergencyType = emergencyType
            self.message = message
            self.timestamp = timestamp
        }
    
    func createReportDict() -> [String: Any] {
        let dict:[String:Any] = [
            "reportID": self.reportID,
            "postedBy": self.postedBy,
            "emergencyType": self.emergencyType,
            "message": self.message,
            "timestamp": self.timestamp
        ]
        return dict
    }

}
