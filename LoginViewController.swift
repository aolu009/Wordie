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
        
    var cell1: InputTableViewCell?
    var cell2: InputTableViewCell?

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
    
    func presentHomeScreen()
    {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
        navigationController?.present(homeVC, animated: true, completion: nil)
    }
    
    
    @IBAction func onLoginButtonPressed(_ sender: UIButton) {
        print(cell1?.textField.text)
        
        let email = cell1!.textField.text
        let pw = cell2!.textField.text

        FIRAuth.auth()!.signIn(withEmail: email!, password: pw!, completion: { (user, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                self.presentHomeScreen()
                
            }
        })
        
    }
    
    
    @IBAction func onFBLoginPressed(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if (facebookResult?.isCancelled)! {
                print("Facebook login was cancelled.")
            } else {
                
                let accessToken = FBSDKAccessToken.current().tokenString
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken!)
                self.fetchCurrentUserFBData()
                
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                  
                    self.presentHomeScreen()

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
                    

               }
            })
        }
    

    
    
    
    
    
}
