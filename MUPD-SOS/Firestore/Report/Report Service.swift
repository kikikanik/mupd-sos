//
//  Report Service.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class ReportService {

    static let shared = ReportService()
    
    // let userService = UserService.shared
    // var currentUser: User?

    let fsCollection = Firestore.firestore().collection("report")
    var sosReports: [Report] = [] //postedMessages array
        
    private init () {
        
    }
    
    // Adding report type/name from 'EmergencyTabViewController'
    func addReportName(report: Report) {
        fsCollection.addDocument(data: report.createReportDict())
    }
    
    // Adding a NEW pin drop with NEW documentID
    func addReport(report: Report) {
        fsCollection.addDocument(data: report.createReportDict()) //sending Report attributes from object to Firestore
    }
    
    //func here to get all the notifications from firestore
    func observeReports () {
        
        fsCollection.addSnapshotListener { (querySnapshot, err) in
           
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.sosReports = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                   
                    if let aReport = Report(data: document.data(), documentID: document.documentID) {
                        self.sosReports.append(aReport)
                    }
                }
            // self.sosReports.removeAll()
                
                NotificationCenter.default.post(name: Notification.Name(rawValue:  kSOSReportsChanged), object: self)
            }
        }
       
    }

}
