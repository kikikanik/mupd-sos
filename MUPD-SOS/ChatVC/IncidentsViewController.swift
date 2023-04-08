//
//  IncidentsViewController.swift
//  MUPD-SOS
//
import UIKit

class IncidentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    let pindropService = PinDropService.shared
    let profileService = ProfileService.shared
    
    var openIncidents: [PinDrop] = [] //njCountiesSorted or shapeList
    var closedIncidents: [PinDrop] = [] //njCountiesSorted or shapeList
    var selectedIncident: PinDrop?
    
    
    @IBOutlet var incidentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incidentsTableView.delegate = self
        incidentsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(incidentsReceived), name: Notification.Name(rawValue: kSOSNotificationsChanged), object: nil)
        pindropService.observeNotifications()
    }
    
    @objc
    func incidentsReceived() {
        openIncidents.removeAll()
        closedIncidents.removeAll()
        for incident in pindropService.notifications {
            if (incident.state == true) {
                openIncidents.append(incident)
            } else {
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
            print("(should be true) incident state: ")
            print (thisIncident.state)
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
            print("(should be false) incident state: ")
            print (thisIncident.state)
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
    
        if indexPath.section == 0 {
            let openIncidents = openIncidents[indexPath.row]
            if (openIncidents.state == true) {
                self.performSegue(withIdentifier: "incidentSegue", sender: self)
            }
            
        }
        else{
            closedIncidentPopUp()
        }
    }
    
    
    func closedIncidentPopUp() {
        let alert = UIAlertController(title: "Closed Incident!", message: "This incident has been closed and can no longer be accessed on this app." + "\n" + "*Contact your IT Representative to reference this data.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let indexPath = self.incidentsTableView.indexPathForSelectedRow!
            
        let tableViewDetail = segue.destination as? IncidentChatViewController
        
        if indexPath.section == 0 {
            let openIncident = openIncidents[indexPath.row]
            if(openIncident.state == true) {
                
                let selectedIncident = openIncidents[indexPath.row]
                tableViewDetail!.selectedIncident = selectedIncident
                tableViewDetail!.button.isEnabled = true
                print(selectedIncident.userID)
                self.incidentsTableView.deselectRow(at: indexPath, animated: true)
                }
        }
        else{
            closedIncidentPopUp()
        }
    }
    
}
    
    
    

