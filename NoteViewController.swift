//
//  NoteViewController.swift
//  Dictionary
//
//  Created by Lu Ao on 11/20/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//
//Load word in user profile if there is any

import UIKit
import Firebase
import FirebaseAuth

@objc protocol NoteViewControllerDataSource {
    @objc optional func noteViewController() -> Word
    @objc optional func noteViewControllerDefinition() -> String
}

class NoteViewController: UIViewController, EditDetailViewControllerDataSource {

    
    @IBOutlet weak var editDefinitionButton: UIButton!
    @IBOutlet weak var pronounceButton: UIButton!
    @IBOutlet weak var buttonOutlet: UIView!
    
    @IBOutlet weak var wordText: UILabel!
    @IBOutlet weak var definitionText: UILabel!
    @IBOutlet weak var exampleText: UILabel!
    
    
    var dataSource: NoteViewControllerDataSource?
    var word: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editDefinitionButton.backgroundColor = UIColor.clear
        
        pronounceButton.backgroundColor = UIColor.white
        pronounceButton.layer.cornerRadius = 0.5 * pronounceButton.bounds.size.width
        pronounceButton.layer.borderColor = UIColor.black.cgColor
        buttonOutlet.layer.cornerRadius = 0.5 * buttonOutlet.bounds.size.width
        self.view.bringSubview(toFront: buttonOutlet)
        self.view.bringSubview(toFront:self.definitionText)
        
        
        
        
        if let word = self.word{ //dataSource?.wordDetailViewController()
            self.wordText.text = word.word
            self.definitionText.text = self.word?.definition[0]
            self.exampleText.text = word.definitionAndExample[self.definitionText.text!]
            /*
            for category in word.categories{
                print("\(category):")
                for definition in word.definition{
                    print("Definition:",definition)
                    if let ex = word.testing[category]?[definition]{
                        print(ex)
                    }
                }
            }
            */
        }
        else{
            print("Nothing Passed to hereeeeeeeeeee")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let vocabulary = self.word?.word{
            FirebaseClient.sharedInstance.getSelfDefinedDefinitionOnWord(word: vocabulary, complete: {(definition) in
                print("It gets here3")
                if let definitoin = definition{
                    self.definitionText.text = definitoin
                }
                else{
                    self.definitionText.text = self.word?.definition[0]
                }
            })
        }
    }
    
    
    
    @IBAction func onSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "SearchTabViewController") as! SearchTabViewController
        //let nxtVC = nxtNVC.topViewController as! EditDetailViewController
        //nxtVC.dataSource = self
        self.present( nxtNVC, animated: true, completion: {
            //self.dismiss(animated: true, completion: nil)
        
        })
    }
    
    @IBAction func onEditingTexfields(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "EditDetailNavController") as! UINavigationController
        let nxtVC = nxtNVC.topViewController as! EditDetailViewController
        nxtVC.dataSource = self
        self.present( nxtNVC, animated: true, completion: nil)
    }
    
    func editDetailViewControllerGetWord() -> String{
        return self.wordText.text!
    }
    func editDetailViewControllerGetDefinition() -> String{
        return self.definitionText.text!
    }

        
    
    
    
}

