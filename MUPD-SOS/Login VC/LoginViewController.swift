import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let userService = UserService.shared
    
    var selectUserType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var EmailInput: UITextField!
    @IBOutlet var PasswordInput: UITextField!
    
    func alertLogin() {
        let alert = UIAlertController(title: "User does not exist!", message: "Please register as a new user", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present (alert, animated: true)
    }
    
    func alertEmptyFields() {
        let alert = UIAlertController(title: "Email/Password field is empty!", message: "Please enter your valid login!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present (alert, animated: true)
    }
    
    @IBAction func SignInButton(_ sender: UIButton) {
        let currentUser = User(id: "", email: "", tac: true, userType: "");
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
        userService.signIn(email: email, password: password, currentUser: currentUser) { [self] response in
            if (!response) {
                alertLogin()
                print("LOGIN FAILED!!!!")
            }
            else {
                performSegue(withIdentifier: "loginSuccess", sender: self)
                print("LOGIN SUCCESSFUL!!")
            }
        }
    }
}
