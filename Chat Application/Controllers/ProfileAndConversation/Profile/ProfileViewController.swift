//
//  ProfileViewController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 02/01/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Kingfisher


class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        profileImgVw.layer.cornerRadius = profileImgVw.bounds.height/2
        profileImgVw.layer.borderWidth = 3
        profileImgVw.layer.borderColor = UIColor.white.cgColor
        
        fetchingProfileImg()
        // Do any additional setup after loading the view.
    }
    
    func fetchingProfileImg(){
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return}
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email )
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        
        StorageManager.shared.downloadURL(for: path) { result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self.profileImgVw.kf.setImage(with: url)
                }
                print(url)
                //self.fetching(url: url)
                
            case.failure(let error):
               print(error)
            }
        }
    }
    
    func fetching(url:URL){
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,error == nil else {return}
            DispatchQueue.main.async {
            let image = UIImage(data: data)
                self.profileImgVw.image = image
        }
    }
  }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Logout"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Are you sure to logout", message: "", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Logout", style: .destructive) { action in
            do{
               try FirebaseAuth.Auth.auth().signOut()
                GIDSignIn.sharedInstance.signOut()
            }catch{
                print("unable to signout due to \(error)")
            }
            
            let storyboard = UIStoryboard(name: "LoginAndRegister", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nv = UINavigationController(rootViewController: vc)
            
            let scenDele = self.view.window?.windowScene?.delegate as! SceneDelegate
            
            scenDele.window?.rootViewController = nv
            
            
//            let window = UIWindow(windowScene: windowScene)
//            let storyboard = UIStoryboard(name: "ProfileAndConversation", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//            let nv = UINavigationController(rootViewController: vc)
//            window.rootViewController = nv
//            self.window = window
//            window.makeKeyAndVisible()
            
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(action)
        alert.addAction(action2)
        
        present(alert, animated: true)
        tableview.deselectRow(at: indexPath, animated: true)
    }
    
    
}
