//
//  MUPDProfileViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 02/03/2023.
//

import UIKit
import FirebaseAuth

class MUPDProfileViewController: UIViewController {

    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    
    var mupdprofile: MUPDProfile?
    var mupdprofiles: [MUPDProfile] = []
    
    var selectDutyType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITextField.textDidEndEditingNotification
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {


        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("Successful log out!")
            
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "id")
            UserDefaults.standard.setValue(nil, forKey: "userID")

            let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Main") as! OpeningPageViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        catch {
            print("Failed to log out")
        }
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
    
    func confirmAlert() {
        let profile = UIAlertController(title: "MUPD Profile", message: "Profile Updated!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
            self.navigationController?.popViewController(animated: true)
        }
        profile.addAction(OKAction)
        self.present(profile, animated: true, completion:nil)
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
        
        confirmAlert()
                    
    }
    
}
