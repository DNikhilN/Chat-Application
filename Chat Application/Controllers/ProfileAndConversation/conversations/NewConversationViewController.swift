//
//  NewConversationViewController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 02/01/23.
//

import UIKit

class NewConversationViewController: UIViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    var users = [[String:String]]()
    var results = [[String:String]]()
    public var completeion:(([String:String]) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        loadingUsersFromDatabase()
//        let demo = ["name":"nikhil"]
//        results.append(demo)
//        tableview.delegate = self
//        tableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func loadingUsersFromDatabase(){
        DatabaseManager.shared.getAllUsers { [weak self] result in
            switch result {
            case .success(let userCollection):
                self?.users = userCollection
                self?.results = self!.users
                self?.tbviewDelegateAndDatasource()
            case .failure(let error):
                print("Failed to get users: \(error)")
            }
        }
    }
    
    func tbviewDelegateAndDatasource(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetUserData = results[indexPath.row]
        self.dismiss(animated: true, completion: { [weak self] in
            self?.completeion?(targetUserData)
            print("completion sucess")
        })
       
    }
    
}

//searchbar metods
extension NewConversationViewController:UISearchBarDelegate{
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchbar.text ?? ""
        if !text.replacingOccurrences(of: " ", with: "").isEmpty{
             results = self.users.filter({($0["name"]?.lowercased().contains((searchbar.text?.lowercased())!))!})
            tableview.reloadData()

        } else {
            results = users
            tableview.reloadData()
        }
        
        //{$0.lowercased().contains(searchBar.text!.lowercased())}
    }
    
}

//tableview methods
extension NewConversationViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        dismiss(animated: true, completion:{ [weak self] in
            self?.completeion?(targetUserData)
        }
)
        
    }
    
}
