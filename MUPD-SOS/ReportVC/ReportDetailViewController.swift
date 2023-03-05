//
//  ReportDetailViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class ReportDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var reportList: UITableView!
    
    var selectedReport : Report!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = selectedReport.emergencyType.capitalized + " Report"
        // Make the VC delegate and datasource
        reportList.dataSource = self
        reportList.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        
        switch(indexPath.row) {
        case 0:
            cell.textLabel?.text = "Title: "
            cell.detailTextLabel?.text = selectedReport?.emergencyType
        case 1:
            cell.textLabel?.text = "Posted By: "
            cell.detailTextLabel?.text = selectedReport?.postedBy
        case 2:
            cell.textLabel?.text = "Time Posted: "
            cell.detailTextLabel?.text = selectedReport?.timestamp
        case 3:
            cell.textLabel?.text = "Message: "
            cell.detailTextLabel?.text = selectedReport?.message
        default:
            cell.textLabel?.text = "?"
            cell.detailTextLabel?.text = "?"
        }
        
        return cell
    }
}
