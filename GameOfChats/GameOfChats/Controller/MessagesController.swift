//
//  ViewController.swift
//  GameOfChats
//
//  Created by Miguel Silva da Rocha Junior on 2/25/18.
//  Copyright © 2018 MiguelRochaJr. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
    }
    
    @objc func handleNewMessage() {
        let newMsgVC = NewMessageController()
        let navController = UINavigationController(rootViewController: newMsgVC)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginVC = LoginController()
        present(loginVC, animated: true, completion: nil)
        
    }

}

