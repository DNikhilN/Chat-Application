//
//  ViewController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 01/01/23.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
       
        // Do any additional setup after loading the view.
    }

   
    

    
    
    @IBAction func newConversationBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "ProfileAndConversation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewConversationViewController") as! NewConversationViewController
        vc.completeion = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        present(vc, animated: true, completion: nil)
        
    }
    
    private func createNewConversation(result:[String:String]){
        
        guard let name = result["name"],let email = result["email"] else {return}
       let storyboard = UIStoryboard(name: "ProfileAndConversation", bundle: nil)
        //let vc =  ChatViewController()
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.isNewConversation = true
        vc.otherUserEmail = email
        vc.title = name
//
    navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    

}


extension ConversationViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath)
        cell.textLabel?.text = "hello i am Nikhil"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "ProfileAndConversation", bundle: nil)
       // let vc = ChatViewController(with: "email")
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.title = "hello"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
}


