//
//  ReportDetailViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class ReportDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let reportCellReuseIdentifier = "reportCell"
    var editedReport: Report?
    var enteredState: Int = 0
    
    // reference to selected tableViewCells section and row
    var selectedIndexPath: IndexPath?

    //reference to service files
    let reportService = ReportService.shared
    let userService = UserService.shared
    
    var reports: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = editedReport?.emergencyType

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: reportCellReuseIdentifier, for: indexPath)
        
        switch(indexPath.row) {
            /*
             var reportID: String
             var emergencyType: String
             var message: String
             var postedBy: String
             var timestamp: String
             */
        case 0:
            cell.textLabel?.text = "Emergency Title: "
            cell.detailTextLabel?.text = editedReport?.emergencyType
        case 1:
            cell.textLabel?.text = "Time Posted: "
            cell.detailTextLabel?.text = editedReport?.timestamp
        case 2:
            cell.textLabel?.text = "Posted By: "
            cell.detailTextLabel?.text = editedReport?.postedBy
        case 3:
            cell.textLabel?.text = "Message: "
            cell.detailTextLabel?.text = editedReport?.emergencyType
        case 4:
            cell.textLabel?.text = "State: "
            // cell.detailTextLabel?.text = String(editedSchool?.properties.rating ?? 0)
           // cell.detailTextLabel?.text = getStars(editedSchool?.properties.rating ?? 0)
        default:
            cell.textLabel?.text = "?"
            cell.detailTextLabel?.text = "?"
        }
        
        return cell
    }

}
