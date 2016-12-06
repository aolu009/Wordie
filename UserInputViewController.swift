//
//  UserInputViewController.swift
//  Wordie
//
//  Created by parry on 11/24/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase

class UserInputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var definitionTextField: UITextField!
    
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    var movieURL:URL?
    var movieCount:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.proceedButton.alpha = 0
    }

    static func instantiateCustom(movieURL: URL, count: Int) -> UserInputViewController
    {
        let inputVC = UIStoryboard(name: "Malcolm.Main", bundle: nil).instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
        inputVC.movieURL = movieURL
        inputVC.movieCount = count

        return inputVC
    }
    
    func unHideProceed()
    {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.proceedButton.alpha = 1

        })
    }

    @IBAction func onProceedButtonPressed(_ sender: UIButton) {
        

        uploadToFirebase()
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Upload"), object: nil)

        })
    }
    
    func uploadToFirebase()
    {
        //create new movie entry with entered properties
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        //FIXME: not gettig a user id
        
        FirebaseClient.sharedInstance.createNewVideoObject(url: movieURL!, movieCount: movieCount!, description: captionTextField.text!, likes: 0, featured: false, definition:definitionTextField.text! , word: wordTextField.text!, subtitles: subtitleTextField.text!, userID: userID!, complete: {
            
            // Dissmissing the camera after successfully upload thus use complete handle
            // Add HUD while loading
            
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if definitionTextField.text != ""  {
            unHideProceed()

    }
    }


}




    
