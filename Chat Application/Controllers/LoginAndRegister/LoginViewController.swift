//
//  LoginViewController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 02/01/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    let alert = UIAlertController(title: "Alert", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(action)
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func registerBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "LoginAndRegister", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
        guard let email = emailTF.text,!email.isEmpty else {
            alert.message = "please enter email id"
            present(alert, animated: true)
            return
        }
        
        guard isValidEmail(email) else{
            alert.message = "please enter valid email id"
            present(alert, animated: true)
            return
        }
        
        
        guard let password = passwordTF.text,!password.isEmpty else {
            alert.message = "please enter password"
            present(alert, animated: true)
            return
        }
        
        guard isValidPassword(password) else{
            alert.message = "please enter valid password"
            present(alert, animated: true)
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResults, error in
            guard let results = authResults,error == nil else {
                self.alert.message = "check your email id and password"
                self.present(self.alert, animated: true)
                return
            }
            let user = results.user
            print("logged in user \(user)")
            
            let storyboard = UIStoryboard(name: "LoginAndRegister", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
            
            let scenDele = self.view.window?.windowScene?.delegate as! SceneDelegate
            
            scenDele.window?.rootViewController = vc
            
      
        }
        
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password:String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: password)
    }

    

}
