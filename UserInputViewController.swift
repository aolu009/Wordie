//
//  UserInputViewController.swift
//  Wordie
//
//  Created by parry on 11/24/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class UserInputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var captionTextField: UILabel!
    
    var movieURL:String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func instantiateCustom(movieURL: String) -> UserInputViewController
    {
        let inputVC = UIStoryboard(name: "Malcolm.Main", bundle: nil).instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
        inputVC.movieURL = movieURL
        
        return inputVC
    }

    @IBAction func onProceedButtonPressed(_ sender: UIButton) {
        
        //create new movie entry with entered properties
        //dismiss viewcontrolelr
    }
    


}
