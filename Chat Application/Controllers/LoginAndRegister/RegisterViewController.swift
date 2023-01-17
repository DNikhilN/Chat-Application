//
//  RegisterViewController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 02/01/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var conformPasswordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!

    let alert = UIAlertController(title: "Alert", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default)
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(action)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        profileImg.layer.cornerRadius = profileImg.bounds.height / 2
        profileImg.layer.borderWidth = 4
        profileImg.layer.borderColor = UIColor.gray.cgColor
        // Do any additional setup after loading the view.
    }

    @IBAction func registerBtn(_ sender: UIButton) {
        
        guard let firstName = firstNameTF.text,!firstName.isEmpty else {
            alert.message = "please enter first name"
            present(alert, animated: true)
            return
        }
        
        guard let lastName = lastNameTF.text,!lastName.isEmpty else {
            alert.message = "please enter last name"
            present(alert, animated: true)
            return
        }
        
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
        
        guard let conformPassword = conformPasswordTF.text,!conformPassword.isEmpty else {
            alert.message = "please enter conform password"
            present(alert, animated: true)
            return
        }
        
        guard let conformPassword = conformPasswordTF.text,conformPassword == password else {
            alert.message = "please check your conform password"
            present(alert, animated: true)
            return
        }
        
        DatabaseManager.shared.userExists(with: email) { exists in
            guard !exists else {
                self.alert.message = "user already exists with this email id"
                self.present(self.alert, animated: true)
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResults, error in
                guard authResults != nil, error == nil else{
                    self.alert.message = "Error creating user"
                    self.present(self.alert, animated: true)
                    return
                }
              
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
            
        }
    
        }
        
        let storyboard = UIStoryboard(name: "ProfileAndConversation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        
        let scenDele = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        scenDele.window?.rootViewController = vc
        
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
    

    @IBAction func tapGestureForProfileImg(_ sender: UITapGestureRecognizer) {
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let camerAction = UIAlertAction(title: "Camera", style: .default) { action in
            
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .destructive) { action in
            
        }
        
        alert.addAction(camerAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(Cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
}


extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
