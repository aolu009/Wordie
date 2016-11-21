//
//  ViewController.swift
//  Dictionary
//
//  Created by Lu Ao on 11/13/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//
//  TabBarControl is in AppDelegate.swift
//

import UIKit
import AFNetworking
import Firebase

class SearchViewController: UIViewController,UITextFieldDelegate,DefinitionTabViewControllerDataSource {

    
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var wordDictionary: Word!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.searchTextField.becomeFirstResponder()
        self.errorMessage.isHidden = true
    }

    
    // Search and fetch entered word on Search Key hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Add logic to prevent passing "" in, will crash otherwise
        if textField.text != ""{
            // Must add logic to show invalid search result
            // See if possible to dynamically show possible searching candidate
            OxfordClient.sharedInstance.searchFromOxford(searchInput: textField.text, success: {(oxfordWord) in
                if let result = oxfordWord.dictionary{
                    self.wordDictionary = Word(dictionary: result)
                    self.wordDictionary.word = self.searchTextField.text
                    //Tesing at log
/*
                    for category in self.wordDictionary.categories{
                        print("\(category):")
                        for definition in self.wordDictionary.definition{
                            print("Definition:",definition)
                            if let ex = self.wordDictionary.testing[category]?[definition]{
                                print(ex)
                            }
                        }
                    }
*/
                    
                    let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
                    let nxtNVC = storyboard.instantiateViewController(withIdentifier: "DefinitionTabViewController") as! DefinitionTabViewController
                    nxtNVC.dataSource = self
                    self.present( nxtNVC, animated: true, completion: nil)
                    
                }
                else{
                    print("No such word in the Oxford Dictionary")
                }
                
            }, failure: {(Error) in
                // Added logic to display different message depend on whether the word is in your own library
                // Will be complete when self library/word set function is accomplished
                self.errorMessage.text = Error
                //self.errorMessage.isHidden = false
                
                UIView.animate(withDuration: 3, animations: {
                    self.errorMessage.isHidden = false
                    self.errorMessage.textColor = UIColor.blue
                })
                //print(Error)
            })
        }
        textField.resignFirstResponder()
        return false
    }
    
    func definitionTabViewController() -> Word {
        return self.wordDictionary
    }
    
    @IBAction func onTextFieldTouched(_ sender: UITextField) {
        //clear the error message
        self.errorMessage.isHidden = true
        self.errorMessage.text = ""
    }
    
   

}
