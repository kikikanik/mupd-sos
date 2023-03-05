//
//  RegisterViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 28/02/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let userService = UserService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    @IBOutlet var EmailInput: UITextField!
    
    @IBOutlet var PasswordInput: UITextField!
 
    @IBAction func RegisterButton(_ sender: UIButton) {

        guard let email = EmailInput.text, !email.isEmpty else {
            print ("Email field is empty!")
            return
        }

        guard let password = PasswordInput.text, !password.isEmpty else {
            print ("Password field is empty!");
            return
        }
        
        //ADD SEGMENTED CONTROL FOR USERTYPE!!!
        let newUser = User(id: email, email: email, tac: true, userType: "MUPD", username: "");
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
