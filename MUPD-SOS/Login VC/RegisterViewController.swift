//
//  RegisterViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 28/02/2023.
//

import UIKit

class RegisterPageViewController: UIViewController {
    
    let userService = UserService.shared //allowing a relationship between view controller and UserModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBOutlet weak var EmailInput: UITextField!
    
    @IBOutlet weak var PasswordInput: UITextField!
    
    
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
        let newUser = User(id: email, email: email, tac: true, userType: "MUPD");
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
