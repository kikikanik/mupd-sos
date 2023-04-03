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
    var selectedUserID = " "
    
    //local vars
    var fullname = " "
    var dob = " "
    var allergies = " "
    var medicalConditions = " "
    var econtactName = " "
    var econtactRelat = " "
    var econtactPhone = " "
    var eyeColor = " "
    var hairColor = " "
    var height = " "
    var weight = " "
    
    //table view local
    @IBOutlet weak var profileTable: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileTable.dataSource = self
        self.profileTable.delegate = self
        //self.title = selectedProfile.userID
        print("selected user id: ")
        print(selectedUserID)
        
        profileService.getProfile(docID: selectedUserID) { response in
            if (response) {
                let fullname = self.profileService.existingProfile.firstName + self.profileService.existingProfile.lastName
                print(fullname)
                let dob = self.profileService.existingProfile.dob
                let allergies = self.profileService.existingProfile.allergies
                let medicalConditions = self.profileService.existingProfile.medicalConditions
                let econtactName = self.profileService.existingProfile.emerContName
                let econtactRelat = self.profileService.existingProfile.emerContRelat
                let econtactPhone = self.profileService.existingProfile.emerContPhone
                let eyeColor = self.profileService.existingProfile.eyeColor
                let hairColor = self.profileService.existingProfile.hairColor
                let height = self.profileService.existingProfile.height
                let weight = self.profileService.existingProfile.weight
                
                print(response)
            }
            else {
                print("NO EXISTING PROFILE TO SHOW!!!")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: pinDropCellReuseIdentifier, for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = fullname
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 1:
            cell.textLabel?.text = "Birthday"
            cell.detailTextLabel?.text = dob
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 2:
            cell.textLabel?.text = "Allergies"
            cell.detailTextLabel?.text = allergies
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 3:
            cell.textLabel?.text = "Medical Conditions"
            cell.detailTextLabel?.text = medicalConditions
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 4:
            cell.textLabel?.text = "Eye Color"
            cell.detailTextLabel?.text = eyeColor
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 5:
            cell.textLabel?.text = "Emergency Contact"
            cell.detailTextLabel?.text = econtactRelat + econtactName
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print ("get cell")
        case 6:
            cell.textLabel?.text = "Emergency Phone"
            cell.detailTextLabel?.text = econtactPhone
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
