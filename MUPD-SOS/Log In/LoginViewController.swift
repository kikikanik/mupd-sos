//
//  LoginViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    let userService = UserService.shared
    
    override func viewDidLoad() {
        
    }
    
    
    @IBOutlet weak var EmailInput: UITextField!
    
    @IBOutlet weak var PasswordInput: UITextField!
    //var EmailInput: UITextField!
        
    @IBAction func SignInButton(_ sender: UIButton) {
        
        let currentUser = User(id: " ", officerTitle: " ", officerFullName: " ", email: " ");
        
        // id: String, officerTitle: String, officerFirstName: String, officerLastName: String, email:String
        
        guard let email = EmailInput.text, !email.isEmpty else {
            print ("Email field is empty!")
            return
        }

        guard let password = PasswordInput.text, !password.isEmpty else {
            print ("Password field is empty!");
            return
        }
        
        userService.signIn(email: email, password: password, currentUser: currentUser) { response in
            if (response) {
                print("LOGIN SUCCESSFUL!!")
            }
            else {
                print("LOGIN FAILED!!!!")
            }
        }
    }
}
