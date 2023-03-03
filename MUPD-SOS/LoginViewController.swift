//
//  LogInViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 28/02/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    let userService = UserService.shared
    
    override func viewDidLoad() {
        
    }
    
    
    @IBOutlet var EmailInput: UITextField!
    @IBOutlet var PasswordInput: UITextField!
 
    
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Invalid Login!", message: "Please register as a new user!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present (alert, animated: true)
    }
    
    
    
    @objc private func loginButtonTapped() {
        
        guard let email = EmailInput.text, let password = PasswordInput.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
    }
    
    func alertLogin(response: Bool) {
        let alert = UIAlertController(title: "User does not exist!", message: "Please register as a new user!", preferredStyle: .alert)
        if response == false {
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else if response == true {
            self.dismiss(animated: false)
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSuccess" {
            let segueShouldOccur = true || false
            if !segueShouldOccur {
                let notPermitted = UIAlertController(title: "Alert", message: "User does not exist! Please register as a new user", preferredStyle: .alert)
                notPermitted.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                // shows alert to user
                present(notPermitted, animated: true)
                
                // prevents the segue from occurring
                return false
            }
           
        }
        //by default, perform the normal segue
        return true
    }
    
    
    
    @IBAction func SignInButton(_ sender: UIButton) {
        
        let currentUser = User(id: "", email: "", tac: true, userType: "student", username: "");
        guard let email = EmailInput.text, !email.isEmpty else {
            print ("Email field is empty!")
            return
        }

        guard let password = PasswordInput.text, !password.isEmpty else {
            print ("Password field is empty!");
            return
        }
       
        self.shouldPerformSegue(withIdentifier: "loginSuccess", sender: sender)

      
        
        userService.signIn(email: email, password: password, currentUser: currentUser) { response in
            
            if (response) {
              //  self.alertLogin(response: true)
               
                print("LOGIN SUCCESSFUL!!")
            }
            else {
             //   self.alertLogin(response: false)
                self.shouldPerformSegue(withIdentifier: "loginSuccess", sender: response)
                print("LOGIN FAILED!!!!")
                
            }
        }
    }
}
