//
//  NoteViewController.swift
//  Dictionary
//
//  Created by Lu Ao on 11/20/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase

protocol NoteViewControllerDataSource {
    func noteViewController() -> Word
}

class NoteViewController: UIViewController {

    
    @IBOutlet weak var pronounceButton: UIButton!
    @IBOutlet weak var buttonOutlet: UIView!
    
    @IBOutlet weak var wordText: UILabel!
    @IBOutlet weak var definitionText: UILabel!
    @IBOutlet weak var exampleText: UILabel!
    
    
    var dataSource: NoteViewControllerDataSource?
    var word: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pronounceButton.backgroundColor = UIColor.white
        pronounceButton.layer.cornerRadius = 0.5 * pronounceButton.bounds.size.width
        pronounceButton.layer.borderColor = UIColor.black.cgColor
        buttonOutlet.layer.cornerRadius = 0.5 * buttonOutlet.bounds.size.width
        
        self.view.bringSubview(toFront: buttonOutlet)
        
        if let word = self.word{ //dataSource?.wordDetailViewController()
            self.wordText.text = self.word?.word
            self.definitionText.text = self.word?.definition[0]
            self.exampleText.text = self.word?.definitionAndExample[self.definitionText.text!]
            for category in word.categories{
                print("\(category):")
                for definition in word.definition{
                    print("Definition:",definition)
                    if let ex = word.testing[category]?[definition]{
                        print(ex)
                    }
                }
            }
        }
        else{
            print("Nothing Passed to hereeeeeeeeeee")
        }
        
        
        
        
    }
    
    @IBAction func onSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
/*
 // Do any additional setup after loading the view.
 //let ref = FIRDatabase.database().reference(withPath: "grocery-items")
 let childRef = FIRDatabase.database().reference(withPath: "grocery-items")
 //let text = ["TESTINGGGGGGG","ANOTHERRRRRRRR","HOW ABOUT THIS"]
 let groceryItemRef = childRef.child("Let's do this")
 //groceryItemRef.setValue(text)
 groceryItemRef.observe(.value, with: { snapshot in
 })
 */
