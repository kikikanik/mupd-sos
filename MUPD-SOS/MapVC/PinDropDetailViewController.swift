//
//  PinDropDetailViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 02/03/2023.
//

import UIKit
import MapKit

class PinDropDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    let pinDropCellReuseIdentifier = "notificationCell"
    var notifName: String = " "
    
    //reference to models
    let userService = UserService.shared
    let pinDropService = PinDropService.shared
    let profileService = ProfileService.shared
    
    // reference to selected tableViewCells section and row
    var selectedIndexPath: IndexPath?
    var selectedItem: PinDrop!
    
    //table view local
    
    @IBOutlet weak var notificationSummary: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notificationSummary.dataSource = self
        self.notificationSummary.delegate = self
        self.title = selectedItem?.notifName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("get cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: pinDropCellReuseIdentifier, for: indexPath)
    switch indexPath.row {
        /*
         var userID: String
         var pinDropId: String
         var userCoordinateLat: Double
         var userCoordinateLong: Double
         var reportedLocationLat: Double
         var reportedLocationLong: Double
         var identity:String
         var acceptedNotif: Bool      //Array<Int>
         var importance: Int
         var notifName: String
         var state: Bool
         var submit: Bool
         var timestamp: String
         */
    case 0:
        cell.textLabel?.text = "Emergency Name"
        cell.detailTextLabel?.text = selectedItem.notifName
    case 1:
        cell.textLabel?.text = "Self or Bystander?"
        cell.detailTextLabel?.text = selectedItem.identity
    case 2:
        cell.textLabel?.text = "User ID"
        cell.detailTextLabel?.text = selectedItem.userID
    case 3:
        cell.textLabel?.text = "Time Reported"
        cell.detailTextLabel?.text = selectedItem.timestamp
    case 4:
        cell.textLabel?.text = "Accept?"
    default:
        cell.textLabel?.text = "type"
        cell.detailTextLabel?.text = "???"
    }
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 18.0)// [UIFont fontWithName:@"Helvetica" size:24.0];
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 18.0)
        cell.detailTextLabel?.textColor = .blue
        return cell
    }
    
    // selected section and row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }

}
