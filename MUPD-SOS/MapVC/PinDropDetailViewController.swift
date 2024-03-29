import UIKit
import MapKit

class PinDropDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UITextFieldDelegate {
    
    let pinDropCellReuseIdentifier = "notificationCell"
    
    //reference to models
    let userService = UserService.shared
    let pinDropService = PinDropService.shared
    let profileService = ProfileService.shared
    
    // reference to selected tableViewCells section and row
    var selectedIndexPath: IndexPath?
    var selectedItem: PinDrop!
    
    var selectedProfileID = " "
    
    var selectedIncidentProfile: Profile!

    var answer: Bool!
    
    //table view local
    @IBOutlet weak var notificationSummary: UITableView!
    
    
    //Text fields to view reporter info
    @IBOutlet weak var reporterFirstName: UITextField!
    
    @IBOutlet weak var reporterLastName: UITextField!
    
    @IBOutlet weak var reporterPhone: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationSummary.dataSource = self
        self.notificationSummary.delegate = self
        self.title = selectedItem.notifName
        print("!!!!selectedItem.userID: ")
        print(selectedItem.userID)
        print("!!!!selectedItem.pinDropId: ")
        print(selectedItem.pinDropId)
        
        reporterFirstName.delegate = self
        reporterLastName.delegate = self
        reporterPhone.delegate = self
        
        profileService.getProfile(docID: selectedProfileID) { response in
            if (response) {
                let firstname = self.profileService.existingProfile!.firstName
                let lastname = self.profileService.existingProfile!.lastName
                let phone = self.profileService.existingProfile!.phone
                print(response)
                
                self.reporterFirstName.text = firstname
                self.reporterLastName.text = lastname
                self.reporterPhone.text = phone
            }
            else {
                print("NO EXISTING PROFILE TO SHOW!!!")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Incident Information" : "Profile Info on Reporter"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: pinDropCellReuseIdentifier, for: indexPath)
        
        //switch
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Emergency Name"
            cell.detailTextLabel?.text = selectedItem.notifName
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 1:
            cell.textLabel?.text = "Self or Bystander?"
            cell.detailTextLabel?.text = selectedItem.identity
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 2:
            cell.textLabel?.text = "User ID"
            cell.detailTextLabel?.text = selectedItem.userID
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 3:
            cell.textLabel?.text = "Time Reported"
            cell.detailTextLabel?.text = selectedItem.timestamp
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 4:
            cell.textLabel?.text = "Accepted?"
            cell.detailTextLabel?.text = " "
            cell.accessoryView = switchView
            switchView.setOn(selectedItem.acceptedNotif, animated: true)
            cell.reloadInputViews()
            print ("get cell")
        case 5:
            cell.textLabel?.text = "Incident Status"
            cell.detailTextLabel?.text = " "
            cell.accessoryView = switchView
            switchView.setOn(selectedItem.state, animated: true)
            
            cell.reloadInputViews()
            print ("get cell")
        default:
            cell.textLabel?.text = "????"
            cell.detailTextLabel?.text = "???"
        }
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 18.0)// [UIFont fontWithName:@"Helvetica" size:24.0];
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 18.0)
        cell.detailTextLabel?.textColor = .blue
        
        return cell
    }
    // selected section and row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedIndexPath = indexPath
    }
    
    func confirmAlert() {
        let alert = UIAlertController(title: "Incident Information", message: "Incident Updated", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button is tapped.
            print("Ok button tapped");
            //self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(OKAction)
        present(alert, animated: true, completion:nil)
    }
    
    @objc func switchChanged(_ sender: UISwitch!) {
        print("Table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "YES" : "NO")")
        
        if (sender.tag == 4) {
            selectedItem.acceptedNotif = sender.isOn
        } else {
            selectedItem.state = sender.isOn
        }
    }
    
    @IBOutlet weak var saveInfo: UIBarButtonItem!
    
    
    
    @IBAction func updateIncident(_ sender: Any) {
        
        print("You pressed me!")
        
        pinDropService.updateNotification(pinDrop: selectedItem, docID: selectedItem.pinDropId)
        
        confirmAlert()
    }
}
