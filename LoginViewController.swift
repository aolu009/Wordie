//
//  LoginViewController.swift
//  Wordie
//
//  Created by parry on 11/21/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import AVFoundation

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var currentUserID: String?
    
    var emailTextField = UITextField()
    var passwordTextField = UITextField()

    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "LOG IN"
        
        self.navigationController?.isNavigationBarHidden = false


    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputTableViewCell
        
        if indexPath.row == 0 {
            let placeholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
            cell.textField.attributedPlaceholder = placeholder
            cell.iconImageView.image = #imageLiteral(resourceName: "email")
            cell.iconImageView.tintColor = UIColor.white
            
        }
        if indexPath.row == 1 {
            let placeholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
            cell.textField.attributedPlaceholder = placeholder
            cell.iconImageView.image = #imageLiteral(resourceName: "password")
            cell.iconImageView.tintColor = UIColor.white
            
        }

        
        
        return cell
    }
    
    
    func getCurrentUser() {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                self.currentUserID = user.uid

            } else {
                // No user is signed in.
            }
        }
        
    }
    
    func storeUser()
    {
        UserDefaults.standard.setValue(false, forKey: "facebook")
        UserDefaults.standard.setValue(emailTextField.text!, forKey: "email")
        UserDefaults.standard.setValue(passwordTextField.text!, forKey: "password")

    }
    
    
    @IBAction func onLoginButtonPressed(_ sender: UIButton) {
        FIRAuth.auth()!.signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!)
        storeUser()
        
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
                                                                        
                                                                        self.storeUser()
                                                                        
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
    
    
    
    @IBAction func onFBLoginPressed(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if (facebookResult?.isCancelled)! {
                print("Facebook login was cancelled.")
            } else {
                print("You’re inz")
                
                let accessToken = FBSDKAccessToken.current().tokenString
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken!)

                
                UserDefaults.standard.setValue(true, forKey: "facebook")
                UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
                
                self.fetchCurrentUserFBData()
                

                
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                  
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)

                }
            }
        })

    }
    
    
    func fetchCurrentUserFBData()
        {
           let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large), username"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
    
                if ((error) != nil)
               {
                    print("Error: \(error)")
                }
                else
                {
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    print(data)
                    
                    let userProfilePicURL = data["picture"]?["data"]
                    let email = data["email"] as! String
                    let userid = data["id"] as! String
                    let firstname = data["first_name"] as! String

                    //facebook does not provide username
                    //storing first name as idt
                    
                    //create new user
                    
                    FirebaseClient.sharedInstance.createNewUser(userEmail: email, userID: userid, userName: firstname)

               }
            })
        }
    

    
    
    
    
    
}
