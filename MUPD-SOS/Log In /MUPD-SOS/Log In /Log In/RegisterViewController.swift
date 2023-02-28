//
//  RegisterViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import UIKit

class RegisterPageViewController: UIViewController {
    
    let userService = UserService.shared //allowing a relationship between view controller and UserModel

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBOutlet weak var titleInput: UITextField!
    
    @IBOutlet weak var fullnameInput: UITextField!
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBAction func Registerbutton(_sender: UIButton) {
        guard let officerTitle = titleInput.text, !officerTitle.isEmpty else {
            print ("Title field is empty!")
            return
        }
        
        guard let officerFullName = fullnameInput.text, !officerFullName.isEmpty else {
            print ("First Name field is empty!")
            return
        }
        
        guard let email = emailInput.text, !email.isEmpty else {
            print ("Email field is empty!")
            return
        }

        guard let password = passwordInput.text, !password.isEmpty else {
            print ("Password field is empty!");
            return
        }
        
        //ADD SEGMENTED CONTROL FOR USERTYPE!!!
        let newUser = User(id: email, officerTitle: officerTitle, officerFullName: officerFullName, email: email);
        
        userService.registerUser(email: email, password: password, currentUser: newUser) { response in
            if (response) {
                print("REGISTRATION SUCCESSFUL!!")
            }
            else {
                print("REGISTRATION FAILED!!!!")
            }
        }
    }
}
