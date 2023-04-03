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
    
    var openIncidents: [PinDrop] = [] //njCountiesSorted or shapeList
    var closedIncidents: [PinDrop] = [] //njCountiesSorted or shapeList
    var selectedIncident: PinDrop?
   
    
    @IBOutlet var incidentsTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        incidentsTableView.delegate = self
        incidentsTableView.dataSource = self
        //setupModeMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationsReceived), name: Notification.Name(rawValue: kSOSNotificaionsChanged), object: nil)
        pindropService.observeNotifications()
    }
    
    @objc
    func notificationsReceived() {
        openIncidents.removeAll()
        closedIncidents.removeAll()
        for incident in pindropService.notifications {
            if (incident.state == true) {
                let incident = PinDrop(acceptedNotif: incident.acceptedNotif, identity: incident.identity, importance: incident.importance, userCoordinateLat: incident.userCoordinateLat, pinDropId: incident.pinDropId, userCoordinateLong: incident.userCoordinateLong, reportedLocationLat: incident.reportedLocationLat, reportedLocationLong: incident.reportedLocationLong, notifName: incident.notifName, state: incident.state, submit: incident.submit, timestamp: incident.timestamp, userID: incident.userID)
                
                openIncidents.append(incident)
            } else {
                let incident = PinDrop(acceptedNotif: incident.acceptedNotif, identity: incident.identity, importance: incident.importance, userCoordinateLat: incident.userCoordinateLat, pinDropId: incident.pinDropId, userCoordinateLong: incident.userCoordinateLong, reportedLocationLat: incident.reportedLocationLat, reportedLocationLong: incident.reportedLocationLong, notifName: incident.notifName, state: incident.state, submit: incident.submit, timestamp: incident.timestamp, userID: incident.userID)
                closedIncidents.append(incident)
            }
        }
        incidentsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? openIncidents.count : closedIncidents.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 2
     }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Open Incidents" : "Closed Incidents"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath) as! CustomIncidentsTableViewCell
        
        if indexPath.section == 0 {
            let thisIncident = openIncidents[indexPath.row]
            cell.title?.text = thisIncident.notifName
            cell.reporter?.text = thisIncident.userID
            if (thisIncident.acceptedNotif == false) {
                cell.sourceImage?.image = UIImage(named: "notAcc")
            } else {
                cell.sourceImage?.image = UIImage(named: "yesAcc")
            }
            return cell
        } else {
            let thisIncident = closedIncidents[indexPath.row]
            cell.title?.text = thisIncident.notifName
            cell.reporter?.text = thisIncident.userID
            cell.sourceImage?.image = UIImage(named: "closed")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
        self.performSegue(withIdentifier: "incidentSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "incidentSegue")
        {
            let indexPath = self.incidentsTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? IncidentChatViewController
             
            if (selectedIncident?.state == true) {
                let selectedIncident = openIncidents[indexPath.row]
                tableViewDetail!.selectedIncident = selectedIncident
                self.incidentsTableView.deselectRow(at: indexPath, animated: true)
            } else {
                let selectedIncident = closedIncidents[indexPath.row]
                tableViewDetail!.selectedIncident = selectedIncident
                self.incidentsTableView.deselectRow(at: indexPath, animated: true)
            }
            self.incidentsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
