//
//  MUPDProfileViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 02/03/2023.
//

import UIKit

protocol JsonEncoding where Self: Encodable{}

extension JsonEncoding {
    func encode(using encoder: JSONEncoder) throws -> Data {
        try encoder.encode(self)
    }
}
extension String: JsonEncoding{}

extension Dictionary where Value == JsonEncoding {
    func encode(using encoder: JSONEncoder) throws -> [Key: String] {
        try compactMapValues {
            try String(data: $0.encode(using: encoder), encoding: .utf8)
        }
    }

}

class MUPDProfileViewController: UIViewController {

    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    
    var mupdprofile: MUPDProfile?
    
    var selectDutyType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            print ("User titlw field is empty!")
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
                UserDefaults.standard.set(saveInfo.isSelected, forKey: "SaveProfile")
            
                performSegue(withIdentifier: "saveProfile", sender: nil)
        
    }
    
}
