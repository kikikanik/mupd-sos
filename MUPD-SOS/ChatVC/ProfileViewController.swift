//
//  ProfileViewController.swift
//  MUPD-SOS
//
import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    let pinDropCellReuseIdentifier = "profileCell"
    
    //reference to models
    let userService = UserService.shared
    let pinDropService = PinDropService.shared
    let profileService = ProfileService.shared
    
    var selectedProfile: Profile!
    var selectedUserID = " "
    
    
    @IBOutlet weak var reporterFirstName: UITextField!
    
    @IBOutlet weak var reporterLastName: UITextField!
    
    @IBOutlet weak var reporterDOB: UITextField!
    
    @IBOutlet weak var reporterPhone: UITextField!
    
    @IBOutlet weak var reporterAllergies: UITextField!
    
    @IBOutlet weak var reporterMedCond: UITextField!
    
    @IBOutlet weak var reporterHeight: UITextField!
    
    @IBOutlet weak var reporterWeight: UITextField!
    
    @IBOutlet weak var reporterEyeColor: UITextField!
    
    @IBOutlet weak var reporterHairColor: UITextField!
    
    @IBOutlet weak var reporterEContName: UITextField!
    
    @IBOutlet weak var reporterEContRelat: UITextField!
    
    @IBOutlet weak var reporterEContPhone: UITextField!
    
    @IBOutlet weak var reporterHomeAddress: UITextField!
    
    @IBOutlet weak var reporterSchoolAddress: UITextField!
    
    

    
    //table view local
    @IBOutlet weak var profileTable: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.profileTable.dataSource = self
        //self.profileTable.delegate = self
        //self.title = selectedProfile.userID
        print("selected user id: ")
        print(selectedProfile)
        print("")
        
        reporterFirstName.delegate = self
        reporterLastName.delegate = self
        reporterDOB.delegate = self
        reporterPhone.delegate = self
        reporterAllergies.delegate = self
        reporterMedCond.delegate = self
        reporterEContName.delegate = self
        reporterEContPhone.delegate = self
        reporterEContRelat.delegate = self
        reporterEyeColor.delegate = self
        reporterHairColor.delegate = self
        reporterHeight.delegate = self
        reporterWeight.delegate = self
        reporterHomeAddress.delegate = self
        reporterSchoolAddress.delegate = self
       
        profileService.getProfile(docID: selectedUserID) { response in
            if (response) {
                let firstName = self.profileService.existingProfile!.firstName
                let lastName = self.profileService.existingProfile!.lastName
                let dob = self.profileService.existingProfile!.dob
                let phone = self.profileService.existingProfile!.phone
                let allergies = self.profileService.existingProfile!.allergies
                let medicalConditions = self.profileService.existingProfile!.medicalConditions
                let econtactName = self.profileService.existingProfile!.emerContName
                let econtactRelat = self.profileService.existingProfile!.emerContRelat
                let econtactPhone = self.profileService.existingProfile!.emerContPhone
                let eyeColor = self.profileService.existingProfile!.eyeColor
                let hairColor = self.profileService.existingProfile!.hairColor
                let height = self.profileService.existingProfile!.height
                let weight = self.profileService.existingProfile!.weight
                let homeaddress = self.profileService.existingProfile!.homeAddress
                let schooladress = self.profileService.existingProfile!.schoolAddress
                
                self.reporterFirstName.text = firstName
                self.reporterLastName.text = lastName
                self.reporterDOB.text = dob
                self.reporterPhone.text = phone
                self.reporterAllergies.text = allergies
                self.reporterMedCond.text = medicalConditions
                self.reporterEContName.text = econtactName
                self.reporterEContRelat.text = econtactRelat
                self.reporterEContPhone.text = econtactPhone
                self.reporterEyeColor.text = eyeColor
                self.reporterHairColor.text = hairColor
                self.reporterHeight.text = height
                self.reporterWeight.text = weight
                self.reporterHomeAddress.text = homeaddress
                self.reporterSchoolAddress.text = schooladress
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 7
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: pinDropCellReuseIdentifier, for: indexPath)
        
//        switch indexPath.row {
//        case 0:
//            cell.textLabel?.text = "Name"
//
//            cell.detailTextLabel?.text = self.selectedProfile.firstName
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            print ("get cell")
//        case 1:
//            cell.textLabel?.text = "Birthday"
//            cell.detailTextLabel?.text = dob
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            print ("get cell")
//        case 2:
//            cell.textLabel?.text = "Allergies"
//            cell.detailTextLabel?.text = allergies
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            print ("get cell")
//        case 3:
//            cell.textLabel?.text = "Medical Conditions"
//            cell.detailTextLabel?.text = medicalConditions
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            print ("get cell")
//        case 4:
//            cell.textLabel?.text = "Eye Color"
//            cell.detailTextLabel?.text = eyeColor
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            print ("get cell")
//        case 5:
//            cell.textLabel?.text = "Emergency Contact"
//            cell.detailTextLabel?.text = econtactRelat + econtactName
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            print ("get cell")
//        case 6:
//            cell.textLabel?.text = "Emergency Phone"
//            cell.detailTextLabel?.text = econtactPhone
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            print ("get cell")
//        default:
//            cell.textLabel?.text = "????"
//            cell.detailTextLabel?.text = "???"
//        }
//        cell.textLabel?.font = UIFont(name: "Helvetica", size: 18.0)// [UIFont fontWithName:@"Helvetica" size:24.0];
//        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 18.0)
//        cell.detailTextLabel?.textColor = .blue
//
//        return cell
//    }
}
