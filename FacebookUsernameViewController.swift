//
//  FacebookUsernameViewController.swift
//  Wordie
//
//  Created by parry on 12/6/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import FirebaseAuth

class FacebookUsernameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    var email: String?
    var photoURL: String?
    var userID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        checkmarkButton.isHidden = true
        userID = FIRAuth.auth()?.currentUser?.uid

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkmarkButton.isHidden = false

    }
    
    
    func onProceedPressed(_ sender: UIButton) {
        
        let username = self.usernameTextField.text
        
        FirebaseClient.sharedInstance.createNewUser(userEmail: email, userID: userID, userName: username, photoURL: photoURL)
                
        let navVC = self.presentingViewController as! UINavigationController
        let signUpVC = navVC.viewControllers[1] as! SignUpViewController

        self.dismiss(animated: true, completion: {signUpVC.performSegue(withIdentifier: "homeSegue2", sender: nil)})
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
