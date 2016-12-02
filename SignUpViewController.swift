//
//  SignUpViewController.swift
//  Wordie
//
//  Created by parry on 12/1/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currentUserID: String?

    var cell1: InputTableViewCell?
    var cell2: InputTableViewCell?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SIGN UP"
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
            cell1 = cell

        }
        if indexPath.row == 1 {
            let placeholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
            cell.textField.attributedPlaceholder = placeholder
            cell.iconImageView.image = #imageLiteral(resourceName: "password")
            cell.iconImageView.tintColor = UIColor.white
            cell.textField.isSecureTextEntry = true
            cell2 = cell

            
        }
        
        
        return cell
    }
    
    @IBAction func onSignUpButtonPressed(_ sender: UIButton) {
        
        let email = cell1!.textField.text
        let pw = cell2!.textField.text
        
        FIRAuth.auth()!.createUser(withEmail: email!,
                                   password: pw!) { user, error in
                                    if error == nil {
                                        FIRAuth.auth()!.signIn(withEmail: email!,
                                                               password: pw!)
                                        
                                        self.storeUser()
                                        
                                        self.getCurrentUser()
                                        FirebaseClient.sharedInstance.createNewUser(userEmail: email!, userID: user?.uid, userName: "nil")
                                        
                                        self.performSegue(withIdentifier: "homeSegue2", sender: nil)
                                        
                                    }
        }
        
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
                    
                    self.performSegue(withIdentifier: "homeSegue2", sender: nil)
                    
                }
            }
        })
        
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
        let email = cell1!.textField.text
        let pw = cell2!.textField.text
        
        UserDefaults.standard.setValue(false, forKey: "facebook")
        UserDefaults.standard.setValue(email!, forKey: "email")
        UserDefaults.standard.setValue(pw!, forKey: "password")
        
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
