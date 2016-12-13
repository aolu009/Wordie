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
    var cell3: InputTableViewCell?
    
    
    var email: String?
    var userID: String?
    var userProfilePicURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SIGN UP"
        self.navigationController?.isNavigationBarHidden = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        if indexPath.row == 2 {
            let placeholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : UIColor.white])
            cell.textField.attributedPlaceholder = placeholder
            cell.iconImageView.image = #imageLiteral(resourceName: "user")
            cell.iconImageView.tintColor = UIColor.white
            cell3 = cell
            
            
        }
        
        
        
        
        return cell
    }
    
    @IBAction func onSignUpButtonPressed(_ sender: UIButton) {
        
        let email = cell1!.textField.text
        let pw = cell2!.textField.text
        let username = cell3!.textField.text
        
        FIRAuth.auth()!.createUser(withEmail: email!,
                                   password: pw!) { user, error in
                                    if error == nil {
                                        FIRAuth.auth()!.signIn(withEmail: email!,
                                                               password: pw!)
                                        
                                        FirebaseClient.sharedInstance.createNewUser(userEmail: email!, userID: user?.uid, userName: username, photoURL: nil)
                                        
                                        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
                                        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                                        self.navigationController?.present(homeVC, animated: true, completion: nil)
                                    }
        }
        
    }
    
    
    func presentUsernameVC()
    {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let usernameVC = storyboard.instantiateViewController(withIdentifier: "FacebookUsernameViewController") as! FacebookUsernameViewController
        usernameVC.email = email
        usernameVC.photoURL = userProfilePicURL
        navigationController?.present(usernameVC, animated: true, completion: nil)
    }
    
    func presentHomeScreen()
    {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
        navigationController?.present(homeVC, animated: true, completion: nil)
    }
    
    
        
    
    
    @IBAction func onFBSignupPressed(_ sender: UIButton) {
        
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
                
                
                self.fetchCurrentUserFBData()
                
                
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    
                    self.presentUsernameVC()
                }
            }
        })
        
    }


    
    func fetchCurrentUserFBData()
    {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                
                let dummy = data["picture"]?["data"] as! NSDictionary
                self.userProfilePicURL = dummy["url"] as! String?
                 self.email = data["email"] as! String

                
            }
        })
    }
    

    

}
