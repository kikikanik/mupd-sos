//
//  Report.swift
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation
import Firebase
import FirebaseFirestore


struct Report {
    var reportID: String
    var officerName: String
    var officerTitle: String
    var emergencyState: Bool
    var emergencyType: String
    var message: String
    var timestamp: String
    
    
    init(reportID: String, officerName: String, officerTitle: String, emergencyState: Bool, emergencyType: String, message: String, timestamp: String) {
        self.reportID = reportID;
        self.officerName = officerName;
        self.officerTitle = officerTitle;
        self.emergencyState = emergencyState;
        self.emergencyType = emergencyType;
        self.message = message;
        self.timestamp = timestamp;
    }
    
    init?(data: [String: Any], documentID: String) {
            guard let reportID = data["reportID"] as? String,
                  let officerName = data["officerName"] as? String,
                  let officerTitle = data["officerTitle"] as? String,
                  let emergencyState = data["emergencyState"] as? Bool,
                  let emergencyType = data["emergencyType"] as? String,
                  let message = data["message"] as? String,
                  let timestamp = data["timestamp"] as? String else {
                return nil
            }
            self.reportID = reportID
            self.officerName = officerName
            self.officerTitle = officerTitle
            self.emergencyState = emergencyState
            self.emergencyType = emergencyType
            self.message = message
            self.timestamp = timestamp
        }
    
    func createReportDict() -> [String: Any] {
        let dict:[String:Any] = [
            "reportID": self.reportID,
            "officerName": self.officerName,
            "officerTitle": self.officerTitle,
            "emergencyState": self.emergencyState,
            "emergencyType": self.emergencyType,
            "message": self.message,
            "timestamp": self.timestamp
        ]
        return dict
    }

}
