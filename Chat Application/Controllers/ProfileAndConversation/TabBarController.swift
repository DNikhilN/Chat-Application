//
//  TabBarController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 04/01/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            navigationController?.setNavigationBarHidden(true, animated: false)
    
        }
    

   

}
