//
//  MUPDProfileViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 02/03/2023.
//

import UIKit

class MUPDProfileViewController: UIViewController {

    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    
    var mupdprofile: MUPDProfile?
    var mupdprofiles: [MUPDProfile] = []
    
    var selectDutyType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(mupdprofilesReceived), name: Notification.Name(rawValue:  kSOSMUPDProfilesChanged), object: nil)
        
       mupdprofileService.observeMUPDProfiles()
        
        UITextField.textDidEndEditingNotification
    }
    
    
    @IBAction func userDuty(_ sender: Any) {
        selectDutyType = (sender as AnyObject).selectedSegmentIndex
    }
    
    @IBOutlet weak var usertitle: UITextField!
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var badge: UITextField!
    
    func alertProfileError(message: String = "You left field(s) blank! If something does not apply to you, please type NA.") {
            let alert = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    
    @IBOutlet weak var saveInfo: UIBarButtonItem!
    
    @IBAction func SaveProfile(_ sender: Any) {
        
        guard let usertitle = usertitle.text, !usertitle.isEmpty else {
            print ("User title field is empty!")
            alertProfileError()
            return
        }
        
        guard let userDuty = selectDutyType == 0 ? "On Duty" : "Off Duty", !userDuty.isEmpty else {
            alertProfileError()
            return
        }
        
        guard let badge = badge.text, !badge.isEmpty else {
            print ("Badge is empty!")
            alertProfileError()
            return
        }
        
        guard let fullname = fullname.text, !fullname.isEmpty else {
            print ("Full Name is empty!")
            alertProfileError()
            return
        }
        
        mupdprofile = MUPDProfile(userID: userService.currentUser!.email, title : usertitle, fullName : fullname, badge : badge, onDuty: userDuty)
                
        mupdprofileService.addMUPDProfileInfo(currentUser: mupdprofile!)
        print("PROFILE SAVED TO DATABASE!")
                
                //Saving profile info in the text fields -> NOT WORKING!!!!!!
                //UserDefaults.standard.set(saveInfo.isSelected, forKey: "SaveProfile")
                    
    }
    
    @objc
    func mupdprofilesReceived() {
        //every time theres new data, this will be called
        //for loop through all notifs and display
        mupdprofiles.removeAll()
        
        for mupdProfile in mupdprofileService.MUPDProfiles {
            let mupdProfile = MUPDProfile(userID: userService.currentUser!.email, title: mupdprofileService.currentProfile!.title, fullName: mupdprofileService.currentProfile!.fullName, badge: mupdprofileService.currentProfile!.badge, onDuty: mupdprofileService.currentProfile!.onDuty)
            
             mupdprofiles.append(mupdProfile)
        }
    }
    
}
