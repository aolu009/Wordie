//
//  EditDetailViewController.swift
//  Wordie
//
//  Created by Lu Ao on 11/28/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//
//  Update word in user profile

import UIKit
import Firebase

@objc protocol EditDetailViewControllerDataSource {
    @objc func editDetailViewControllerGetWord() -> String
    @objc func editDetailViewControllerGetDefinition() -> String
}

class EditDetailViewController: UIViewController,UITextViewDelegate {

    var dataSource: EditDetailViewControllerDataSource?
    var definition: String?
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var definitionTextfield: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definitionTextfield.delegate = self
        self.definitionTextfield.becomeFirstResponder()
        self.word.text = self.dataSource?.editDetailViewControllerGetWord()
        self.definitionTextfield.text = self.dataSource?.editDetailViewControllerGetDefinition()
        
    }

    func textViewDidChange(_ textView: UITextView) {
        self.definition = textView.text
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    @IBAction func onBack(_ sender: Any) {
        FirebaseClient.sharedInstance.addDefinitionToWord(word: self.word.text!, definition: self.definition!, complete: {(newDefinition) in
            print("New:",newDefinition)
            self.dismiss(animated: true, completion: nil) //Crashes if nothing changed
        })
    }

}

