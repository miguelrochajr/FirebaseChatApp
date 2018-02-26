//
//  ViewController.swift
//  GameOfChats
//
//  Created by Miguel Silva da Rocha Junior on 2/25/18.
//  Copyright © 2018 MiguelRochaJr. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout(){
        let loginVC = LoginController()
        present(loginVC, animated: true, completion: nil)
        
    }

}

