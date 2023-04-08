//
//  CreateReportViewController.swift
//  MUPD-SOS
//

import UIKit
import Firebase
import FirebaseFirestore

class CreateReportViewController: UIViewController {
    
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    let reportService = ReportService.shared
    
    var report: Report?
    var mupdProfile: MUPDProfile?
    
    let db = Firestore.firestore()
    var postedBy = " "
    
    @IBOutlet weak var EmergencyType: UITextField!
    
    @IBOutlet weak var Message: UITextView!
    
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    @IBAction func uploadReport(_ sender: UIBarButtonItem) {
        guard let EmergencyType = EmergencyType.text, !EmergencyType.isEmpty else {
            print ("Emergency Title is empty!")
            alertReportError()
            return
        }
        
        guard let Message = Message.text, !Message.isEmpty else {
            print ("Message is empty!")
            alertReportError()
            return
        }
        
        mupdprofileService.getMUPDProfile(docID: userService.currentUser!.email) { [self] response in
            if (response) {
                postedBy = self.mupdprofileService.existingMUPDProfile.title + " " + self.mupdprofileService.existingMUPDProfile.fullName
                print("postedBy Field: ")
                print(postedBy)
                print(response)
            }
            else {
                print("NO EXISTING PROFILE TO SHOW!!!")
            }
            
            report = Report(reportID: convertTimestamp(), emergencyType: EmergencyType, message: Message, postedBy: postedBy, timestamp: convertTimestamp())
            reportService.addReport(report: report!, docID: report!.reportID)
            print("REPORT SAVED TO DATABASE!")
        }
        confirmAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alertReportError(message: String = "Please enter all information before posting a report! ") {
            let alert = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }

    func convertTimestamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss.SSSS"
        let currentTime = dateFormatter.string(from: date)
        return currentTime
    }
    
    func confirmAlert() {
        let report = UIAlertController(title: "MUPD Report", message: "Report Reported", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
            self.navigationController?.popViewController(animated: true)
        }
        report.addAction(OKAction)
        self.present(report, animated: true, completion:nil)
    }
}
