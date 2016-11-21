//
//  LoginViewController.swift
//  Wordie
//
//  Created by parry on 11/21/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onLoginButtonPressed(_ sender: UIButton) {
//        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
//                               password: textFieldLoginPassword.text!)
        
    }
    
    @IBAction func onSignUpButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .default) { action in
//                                        let emailField = alert.textFields![0]
//                                        let passwordField = alert.textFields![1]
//                                        
//                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
//                                                                   password: passwordField.text!) { user, error in
//                                                                    if error == nil {
//                                                                        FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
//                                                                                               password: self.textFieldLoginPassword.text!)
//                                                                    }
//                                        }
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
//        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    



}
