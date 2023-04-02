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
   
    // model variable - variable to instantiate the model
    //var incidentsViewModel = Menu (currentMode: IncidentsViewModes.all)
    
    @IBOutlet var incidentsTableView: UITableView!
    
   // @IBOutlet weak var modeSelection: UIBarButtonItem!
    
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
        incidents.removeAll()
        for incident in pindropService.notifications {
            let incident = PinDrop(acceptedNotif: incident.acceptedNotif, identity: incident.identity, importance: incident.importance, userCoordinateLat: incident.userCoordinateLat, pinDropId: incident.pinDropId, userCoordinateLong: incident.userCoordinateLong, reportedLocationLat: incident.reportedLocationLat, reportedLocationLong: incident.reportedLocationLong, notifName: incident.notifName, state: incident.state, submit: incident.submit, timestamp: incident.timestamp, userID: incident.userID)
            
            incidents.append(incident)
        }
        incidentsTableView.reloadData()
    }
  /*
    func setupModeMenu() {
        let allIncidents = UIAction(title:"All Incidents") { (action) in self.selectMode (mode: .all)
        }
        let activeIncidents = UIAction(title:"Active Incidents") { (action) in self.selectMode(mode: .active)
        }
        let closedIncidents = UIAction(title:"Closed Incidents") { (action) in self.selectMode(mode: .closed)
        }
        let menu = UIMenu (title: "View Incidents", children: [allIncidents, activeIncidents, closedIncidents])
        modeSelection.menu = menu
        modeSelection.primaryAction = nil
    }
    
    func selectMode(mode: IncidentsViewModes) {
        incidentsViewModel.currentMode = mode
        self.title = incidentsViewModel.currentMode.rawValue + "Incidents"
    }
    */
    
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
            
            let selectedIncident = incidents[indexPath.row]
            
            tableViewDetail!.selectedIncident = selectedIncident
            
            self.incidentsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
