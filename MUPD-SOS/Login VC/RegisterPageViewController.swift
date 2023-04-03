//
//  RegisterViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 28/02/2023.
//

import UIKit

class RegisterPageViewController: UIViewController {
    
    let userService = UserService.shared //allowing a relationship between view controller and UserService
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet var EmailInput: UITextField!
    @IBOutlet var PasswordInput: UITextField!
    
    var selectUserType = 0
 
    
    @objc private func RegisterButtonTapped() {
        guard let email = EmailInput.text, let password = PasswordInput.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            return
        }
    }
    
    func alertRegistration() {
        let alert = UIAlertController(title: "Invalid username!", message: "Please enter a valid email address or check if you are already an existing user!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present (alert, animated: true)
    }
    
    func alertEmptyFields() {
        let alert = UIAlertController(title: "Email/Password field is empty!", message: "Please enter your valid login!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present (alert, animated: true)
    }
    
    @IBAction func RegisterButton(_ sender: UIButton) {
        
        guard let email = EmailInput.text, !email.isEmpty else {
            alertEmptyFields()
            print ("Email field is empty!")
            return
        }
        guard let password = PasswordInput.text, !password.isEmpty else {
            alertEmptyFields()
            print ("Password field is empty!");
            return
        }
        
        let userType = "MUPD"
        
        let newUser = User(id: email, email: email, tac: false, userType: userType);
        userService.registerUser(email: email, password: password, currentUser: newUser) { [self] response in
            if (!response) {
                alertRegistration()
                print("REGISTRATION FAILED!!")
            }
            else {
                performSegue(withIdentifier: "registerSuccess", sender: nil)
                print("REGISTRATION SUCESSFUL!!!!")
            }
        }
    }
}
