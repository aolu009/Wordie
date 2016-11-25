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
    
    class var currentUser: FIRUser? {
        get {
            let defaults = UserDefaults.standard
            
            if let userData = defaults.object(forKey: kUserDefaultsCurrentUserDataKey) as? Data {
                let dictionary = try! JSONSerialization.jsonObject(with: userData, options: [])
                return user
            }
            
            return nil
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            // Unwrap user and save serialized (dict) info to defaults
            if let user = user {
                // Save serialized dictionary of user
                let data = try! JSONSerialization.data(withJSONObject: user.userDictionary, options: [])
                defaults.set(data, forKey: kUserDefaultsCurrentUserDataKey)
                print("Serialized current user and saving to defaults")
            }
            else {
                defaults.removeObject(forKey: kUserDefaultsCurrentUserDataKey)
            }
            
            defaults.synchronize()
        }
    }

    
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
    
    func storeToDefaults()
    {
        
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
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        FIRAuth.auth()!.signIn(withEmail: self.emailTextField.text!,
                                                                                               password: self.passwordTextField.text!)
                                                                    
                                                                        self.getCurrentUser()
                                                                        
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
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
