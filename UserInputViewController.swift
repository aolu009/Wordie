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
    @IBOutlet weak var captionTextField: UILabel!
    
    var movieURL:String?
    var movieCount:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func instantiateCustom(movieURL: String, count: Int) -> UserInputViewController
    {
        let inputVC = UIStoryboard(name: "Malcolm.Main", bundle: nil).instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
        inputVC.movieURL = movieURL
        inputVC.movieCount = count

        return inputVC
    }

    @IBAction func onProceedButtonPressed(_ sender: UIButton) {
        
        //create new movie entry with entered properties
        let userID = FIRAuth.auth()?.currentUser?.uid
        
    
        FirebaseClient.sharedInstance.createNewVideoObject(url: movieURL, movieCount: movieCount, description: captionTextField.text, word: wordTextField.text, likes: 0, featured: 0, definition: "fsggsfsgf", subtitles: subtitleTextField.text, userID: userID, complete: {
            // Dissmissing the camera after successfully upload thus use complete handle
            // Add HUD while loading
            
        })

        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    


}



    
