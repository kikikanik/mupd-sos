//
//  ProfileViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 14/03/2023.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let pinDropCellReuseIdentifier = "profileCell"
    
    //reference to models
    let userService = UserService.shared
    let pinDropService = PinDropService.shared
    let profileService = ProfileService.shared
    
    var selectedProfile: Profile!
    
    //table view local
    @IBOutlet weak var profileTable: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileTable.dataSource = self
        self.profileTable.delegate = self
        //self.title = selectedProfile.userID
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: pinDropCellReuseIdentifier, for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = selectedProfile.firstName + selectedProfile.lastName
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 1:
            cell.textLabel?.text = "Title"
            cell.detailTextLabel?.text = selectedProfile.title
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 2:
            cell.textLabel?.text = "Contact Number"
            cell.detailTextLabel?.text = selectedProfile.phone
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 3:
            cell.textLabel?.text = "Medical Conditions"
            cell.detailTextLabel?.text = selectedProfile.medicalConditions
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 4:
            cell.textLabel?.text = "Allergies"
            cell.detailTextLabel?.text = selectedProfile.allergies
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 5:
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = selectedProfile.schoolAddress
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 6:
            cell.textLabel?.text = "Emergency Contact"
            cell.detailTextLabel?.text = selectedProfile.emerContRelat + selectedProfile.emerContName + selectedProfile.emerContPhone
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
}
