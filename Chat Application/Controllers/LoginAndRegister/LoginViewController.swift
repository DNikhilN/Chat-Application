//
//  LoginViewController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 02/01/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    let alert = UIAlertController(title: "Alert", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default)
    let spinner = JGProgressHUD()
    
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
    
    @IBAction func googleSign(_ sender: UIButton) {
        
       // spinner.show(in: view)
        guard let clientId = FirebaseApp.app()?.options.clientID else {return }
        let config = GIDConfiguration(clientID: clientId)
        
        
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
//            DispatchQueue.main.async {
//                self.spinner.dismiss()
//            }
//
            guard let autentication = user?.authentication,let idToken = autentication.idToken else {
                print("failed to get user \(error)")
                return}
            
            if let error = error {
                print("hello babu\(error)")
                return}
            
            
            
            guard let email = user?.profile?.email,let firstName = user?.profile?.givenName,let lastName = user?.profile?.familyName else {return}
            
            UserDefaults.standard.set(email, forKey: "email")
            
            DatabaseManager.shared.userExists(with: email) { exsists in
                
                if !exsists {
                    
                    let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser) { succcess in
                        if succcess {
                            //upload image
                            if ((user?.profile?.hasImage) != nil) {
                                
                                guard let url = user?.profile?.imageURL(withDimension: 200) else {return}
                                
                                URLSession.shared.dataTask(with: url) { data, _, _ in
                                    guard let data  = data else {return}
                                    
                                    let fileName = chatUser.profilePictureFileName
                                    StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                                        switch result {
                                        case.success(let downloadUrl):
                                            UserDefaults.standard.setValue(downloadUrl, forKey: "profile_picture_url")
                                            print(downloadUrl)
                                        case .failure(let error):
                                            print("storage manager error: \(error)")
                                            
                                        }
                                    }
                                    
                                    
                                }.resume()
                                
                                
                            }
                        }
                    }
                }
            }
            
           
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: autentication.accessToken)
            
            FirebaseAuth.Auth.auth().signIn(with: credentials) { authResult, error in
                if authResult != nil,error == nil {
                    print("credentials not geting \(String(describing: error))")
                }
                
            }
            
            
            print(credentials)
            let storyboard = UIStoryboard(name: "ProfileAndConversation", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            
            let scenDele = self.view.window?.windowScene?.delegate as! SceneDelegate
            
            scenDele.window?.rootViewController = vc
            
            
            
        }
        
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
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResults, error in
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            UserDefaults.standard.set(email, forKey: "email")
            
            guard let results = authResults,error == nil else {
                self.alert.message = "check your email id and password"
                self.present(self.alert, animated: true)
                return
            }
            let user = results.user
            print("logged in user \(user)")
            
            let storyboard = UIStoryboard(name: "ProfileAndConversation", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            
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
