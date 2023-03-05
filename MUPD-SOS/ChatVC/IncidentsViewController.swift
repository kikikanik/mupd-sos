//
//  IncidentsViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class IncidentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    let pindropService = PinDropService.shared
    
    var incidents: [PinDrop] = [] //njCountiesSorted or shapeList
    var selectedIncident: PinDrop?
    
    @IBOutlet var incidentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incidentsTableView.delegate = self
        incidentsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationsReceived), name: Notification.Name(rawValue: kSOSNotificaionsChanged), object: nil)
        pindropService.observeNotifications()
    }
    
    @objc
    func notificationsReceived() {
        incidents.removeAll()
        for incident in pindropService.notifications {
            let incident = PinDrop(acceptedNotif: incident.acceptedNotif, identity: incident.identity, importance: incident.importance, userCoordinateLat: incident.userCoordinateLat, pinDropId: incident.pinDropId, userCoordinateLong: incident.userCoordinateLong, reportedLocationLat: incident.reportedLocationLat, reportedLocationLong: incident.reportedLocationLong, notifName: incident.notifName, state: incident.state, submit: incident.submit, timestamp: incident.timestamp, userID: incident.userID)
            
            //Report(reportID: userService.currentUser!.email, emergencyType: report.emergencyType, message: report.message, postedBy: report.postedBy, timestamp: report.timestamp)

            incidents.append(incident)
        }
        incidentsTableView.reloadData()
        print("this is all incidents:" )
        print(incidents)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath)
        
        let thisIncident = incidents[indexPath.row]
        
        cell.textLabel?.text = thisIncident.notifName
        cell.detailTextLabel?.text = thisIncident.userID
        
        return cell
    }
}
