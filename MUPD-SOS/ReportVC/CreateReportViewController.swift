//
//  CreateReportViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 02/03/2023.
//

import UIKit

class CreateReportViewController: UIViewController {
    
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    let reportService = ReportService.shared
    
    var report: Report?
    
    @IBOutlet weak var EmergencyType: UITextField!
    
    @IBOutlet weak var Message: UITextField!
    
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
        report = Report(reportID: userService.currentUser!.email, emergencyType: EmergencyType, message: Message, postedBy: "MUPD", timestamp: convertTimestamp())
        reportService.addReportInfo(currentUser: report!)
        print("REPORT SAVED TO DATABASE!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func alertReportError(message: String = "Please enter all information before posting a report! ") {
            let alert = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }

    func convertTimestamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let currentTime = dateFormatter.string(from: date)
        return currentTime
    }
}
