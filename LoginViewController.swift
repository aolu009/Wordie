//
//  LoginViewController.swift
//  Wordie
//
//  Created by parry on 11/21/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var currentUserID: String?

    
      override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func getCurrentUser() {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                self.currentUserID = user.uid

                UserDefaults.standard.setValue(self.currentUserID, forKey: "uid")

            } else {
                // No user is signed in.
            }
        }
        
    }
    
    
    
    @IBAction func onLoginButtonPressed(_ sender: UIButton) {
        FIRAuth.auth()!.signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!)
        self.getCurrentUser()

        performSegue(withIdentifier: "homeSegue", sender: nil)
        
    }
    
    @IBAction func onSignUpButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let userName = alert.textFields![2]
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        FIRAuth.auth()!.signIn(withEmail: self.emailTextField.text!,
                                                                                               password: self.passwordTextField.text!)
                                                                        
                                                                        self.getCurrentUser()
                                                                        FirebaseClient.sharedInstance.createNewUser(userEmail: emailField.text, userID: user?.uid, userName: userName.text)
                                                                        
                                                                        self.performSegue(withIdentifier: "homeSegue", sender: nil)
                                                                    }
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        alert.addTextField { userName in
            userName.placeholder = "Enter your User Name"
        }
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
