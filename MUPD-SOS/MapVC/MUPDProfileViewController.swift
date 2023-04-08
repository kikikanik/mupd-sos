//
//  MUPDProfileViewController.swift
//  MUPD-SOS
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MUPDProfileViewController: UIViewController, UITextFieldDelegate {
    
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    
    var mupdprofile: MUPDProfile?
    var userProfile: [MUPDProfile] = []
    let defaults = UserDefaults.standard
        
    var selectDutyType = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var badgeLabel: UILabel!
    
    @IBOutlet weak var usertitle: UITextField!
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var badge: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullname.delegate = self
        usertitle.delegate = self
        badge.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mupdprofileService.getMUPDProfile(docID: userService.currentUser!.email) { response in
            if (response) {
                let fullname = self.mupdprofileService.existingMUPDProfile.fullName
                let usertitle = self.mupdprofileService.existingMUPDProfile.title
                let badge = self.mupdprofileService.existingMUPDProfile.badge
                print(response)
                
                self.fullname.text = fullname
                self.badge.text = badge
                self.usertitle.text = usertitle
            }
            else {
                print("NO EXISTING PROFILE TO SHOW!!!")
            }
        }
    }
        
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
           // self.navigationController?.dismiss(animated: false)
            performSegue(withIdentifier: "unwindToOpeningPage", sender: self)
            print("Successful log out!")
            /*
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "id")
            UserDefaults.standard.setValue(nil, forKey: "userID")
            
            let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Main") as! OpeningPageViewController
            self.present(newViewController, animated: true, completion: nil)
            //unwind when log out, instead of just 'layer' another login
            //not managing objects correctly
            //unwind
            //implenment method in login, that it clears everything once you open the app
             */
        }
        catch {
            print("Failed to log out")
        }
    }
    
    @IBAction func userDuty(_ sender: Any) {
        selectDutyType = (sender as AnyObject).selectedSegmentIndex
    }
    
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
        
        mupdprofileService.addMUPDProfileInfo(currentUser: mupdprofile!) { response in
            if (response) {
                print("PROFILE SUCCESSFUL!!")
            }
            else {
                print("PROFILE FAILED!!!!")
            }
        }
        print("PROFILE SAVED TO DATABASE!")
        
        confirmAlert()
    }
}
