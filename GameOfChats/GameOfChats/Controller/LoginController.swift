//
//  LoginController.swift
//  GameOfChats
//
//  Created by Miguel Silva da Rocha Junior on 2/25/18.
//  Copyright © 2018 MiguelRochaJr. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(r: 80, g: 101, b: 161, a: 1)
        btn.setTitle("Register", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        btn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handleLoginRegister (){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
            print("HANDLE LOGIN!!!")
        } else {
            handleRegister()
            print("HANDLE USER REGISTRATION!")
        }
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if  error != nil {
                print(error!)
                return
            }
            
            // succesfully logged in the use
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleRegister(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // successfully authenticated user
            let ref = Database.database().reference(fromURL: "https://gameofchats-a22ff.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (updateError, ref) in
                if updateError != nil {
                    print(updateError!)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
//                print("Saved user succesfully into Firebase DB!")
            })
        }
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // see video explaining lazy var: https://youtu.be/DYsfAD01fYk
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151, a: 1)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
    }
    
    func setupLoginRegisterSegmentedControl(){
        // x, y, width and height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupProfileImageView() {
        // x, y, width and height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegisterButton() {
        // x, y, width and height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        // x, y, width and height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // x, y, width and height constraints
        nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // x, y, width and height constraints
        nameSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        // x, y, width and height constraints
        emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        
        // x, y, width and height constraints
        emailSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // x, y, width and height constraints
        passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
}

extension UIColor {

    convenience init (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
