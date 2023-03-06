//
//  ReportService.swift
//  ReportDemo
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

class ReportService {
    
    static let shared = ReportService()
    
    let userService = UserService.shared
    
    let fsCollection = Firestore.firestore().collection("report")
    
    var mupdreports: [Report] = []
    
    var currentUser: User!
    
    private init () {
        
    }
    
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
  /*
    func addReportInfo(report: Report) {
        //let uid = userService.currentUser!.documentID!
        let newDocumentID = UUID().uuidString
        //let uid = report.reportID
        print ("UNIQUE IDENTIFIER OF Report: \(newDocumentID)")
       // self.addReport(report: currentUser, docID: uid)
        self.addReport(report: report, docID: newDocumentID)
    }
    */
    func getReportInfo(forReportId id: String) -> Report? {
        if let index = (mupdreports).firstIndex(where: {$0.reportID == id}) {
            return mupdreports[index]
        }
        return nil;
    }
     
    //func here to get all the notifications from firestore
    func observeReports () {
        
        fsCollection.addSnapshotListener { [self] (querySnapshot, err) in
            mupdreports.removeAll()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    if let aReport = Report(data: document.data(), documentID: document.documentID) {
                        print("Success adding report to array aReport")
                        self.mupdreports.append(aReport)
                    } else {
                        print("Error adding reports to array aReports")
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: kSOSReportsChanged), object: self)
            }
        }
       
    }
    
}
