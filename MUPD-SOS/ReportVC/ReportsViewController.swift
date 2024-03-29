//
//  ReportsViewController.swift
//  MUPD-SOS
//

import UIKit

class ReportsViewController: UIViewController {
    
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    let reportService = ReportService.shared
    
    var reports: [Report] = [] //njCountiesSorted or shapeList
    var selectedReport: Report?
    var editedReport: Report? //editedScoolΩ
    var enteredState: Int = 0
    
    @IBOutlet var reportsTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        reportsTableView.delegate = self
        reportsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reportsReceived), name: Notification.Name(rawValue: kSOSReportsChanged), object: nil)
        reportService.observeReports()
    }
    
    @objc
    func reportsReceived() {
        reports.removeAll()
        for report in reportService.mupdreports {
            let report = Report(reportID: report.reportID, emergencyType: report.emergencyType, message: report.message, postedBy: report.postedBy, timestamp: report.timestamp)

            reports.append(report)
        }
        reportsTableView.reloadData()
        print("this is all reports:" )
        print(reports)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "createReportSegue") {
            let dvc = segue.destination as! CreateReportViewController
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "detailSegue")
        {
            let indexPath = self.reportsTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? ReportDetailViewController
            
            let selectedReport = reports[indexPath.row]
            
            tableViewDetail!.selectedReport = selectedReport
            
            self.reportsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension ReportsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension ReportsViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") as! ReportTableViewCell
        
        let thisReport = reports[indexPath.row]
        
        cell.emergencyType?.text = thisReport.emergencyType
        cell.postedByLabel?.text = thisReport.postedBy
        
    switch (thisReport.emergencyType) {
        
        case "Medical Emergency":
            cell.imageView?.image = UIImage(named: "medical")
        case "Car Hazard":
            cell.imageView?.image = UIImage(named: "carhazard")
        case "Car Accident":
            cell.imageView?.image = UIImage(named: "accident")
        case "Weather":
            cell.imageView?.image = UIImage(named: "weather")
        case "Inclement Weather":
            cell.imageView?.image = UIImage(named: "weather")
        case "Active Shooter":
            cell.imageView?.image = UIImage(named: "shooter")
        case "Fire":
            cell.imageView?.image = UIImage(named: "fire")
        case "Gas Leak":
            cell.imageView?.image = UIImage(named: "gas")
        case "Mental Emergency":
            cell.imageView?.image = UIImage(named: "mental")
        case "Rabid Animal":
            cell.imageView?.image = UIImage(named: "rabidanimal")
        case "Suspicious Person":
            cell.imageView?.image = UIImage(named: "susperson")
        default:
             cell.imageView?.image = UIImage(named: "mupdsos")
        }
         
        return cell
        
        }
}
