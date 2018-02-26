//
//  NewMessageController.swift
//  GameOfChats
//
//  Created by Miguel Silva da Rocha Junior on 2/26/18.
//  Copyright © 2018 MiguelRochaJr. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = User()
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    user.name = name
                    user.email = email
                    self.users.append(user)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                    
                }
            }
        }
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let's use a hack for now
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


















// bottom
