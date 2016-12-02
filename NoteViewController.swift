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

class NoteViewController: UIViewController, EditDetailViewControllerDataSource,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var exampleTable: UITableView!
    @IBOutlet weak var definitionTable: UITableView!
    
    @IBOutlet weak var pronounceButton: UIButton!
    @IBOutlet weak var buttonOutlet: UIView!
    @IBOutlet weak var Synonym: UILabel!
    @IBOutlet weak var Antonym: UILabel!
    
    @IBOutlet weak var wordText: UILabel!
    
    
    var dataSource: NoteViewControllerDataSource?
    var word: Word?
    var editType:String?
    var definitions: [String]?
    var definitionsToDisplay: [Bool]?
    var examplesToDisplay: [Bool]?
    var examples: [String]?
    var definitionOnScreen = [String]()
    var exampleOnScreen = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definitionTable.delegate = self
        self.definitionTable.dataSource = self
        self.definitionTable.rowHeight = 20
        self.exampleTable.delegate = self
        self.exampleTable.dataSource = self
        self.exampleTable.rowHeight = 20
        
        pronounceButton.backgroundColor = UIColor.white
        pronounceButton.layer.cornerRadius = 0.5 * pronounceButton.bounds.size.width
        pronounceButton.layer.borderColor = UIColor.black.cgColor
        buttonOutlet.layer.cornerRadius = 0.5 * buttonOutlet.bounds.size.width
        self.view.bringSubview(toFront: buttonOutlet)
        
        if let word = self.word{
            self.wordText.text = word.word
        }
        else{
            print("Nothing Passed to hereeeeeeeeeee")
        }
        print("Loaded2")
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let vocabulary = self.word?.word{
            FirebaseClient.sharedInstance.getSelfDefinedDefinitionOnWord(word: vocabulary, complete: {(definitions,definitionsToDisplay) in
                if let definitions = definitions{
                    self.definitions = definitions
                }
                if let definitionsDisplay = definitionsToDisplay{
                    self.definitionsToDisplay = definitionsDisplay
                }
                var idx = 0
                self.definitionOnScreen = [String]()
                for definition in self.definitions!{
                    if  idx < (self.definitionsToDisplay?.count)! && (self.definitionsToDisplay?[idx])! == true{
                        self.definitionOnScreen.append(definition)
                    }
                    else{
                        self.definitionOnScreen.append(definition)
                    }
                    idx+=1
                }
                
                self.definitionTable.reloadData()
            })
            FirebaseClient.sharedInstance.getSelfDefinedExampleOnWord(word: vocabulary, complete: {(examples,examplesToDisplay) in
                if let examples = examples{
                    self.examples = examples
                }
                if let examplesToDisplay = examplesToDisplay{
                    self.examplesToDisplay = examplesToDisplay
                }
                var idx = 0
                self.exampleOnScreen = [String]()
                for examples in self.examples!{
                    if (self.examplesToDisplay?[idx])! == true{
                        self.exampleOnScreen.append(examples)
                    }
                    idx+=1
                }
                self.exampleTable.reloadData()
            })
            FirebaseClient.sharedInstance.getSelfDefinedSynonymOnWord(word: vocabulary, complete: {(definitions) in
                if let definitions = definitions{
                    for definition in definitions{
                        self.Synonym.text =  self.Synonym.text! + definition + "\n"
                    }
                }
                else{
                    self.Synonym.text = "Please Enter Synonym"
                }
            })
            FirebaseClient.sharedInstance.getSelfDefinedAntonymOnWord(word: vocabulary, complete: {(definitions) in
                if let definitions = definitions{
                    for definition in definitions{
                        self.Antonym.text =  self.Antonym.text! + definition + "\n"
                    }
                }
                else{
                    self.Antonym.text = "Please Enter Antonym"
                }
            })
            self.definitionTable.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.definitionTable{
            let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
            let nxtNVC = storyboard.instantiateViewController(withIdentifier: "EditDetailNavController") as! UINavigationController
            let nxtVC = nxtNVC.topViewController as! EditDetailViewController
            nxtVC.dataSource = self
            self.editType = "Definition"
            self.present( nxtNVC, animated: true, completion: nil)
        }
        else{
            let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
            let nxtNVC = storyboard.instantiateViewController(withIdentifier: "EditDetailNavController") as! UINavigationController
            let nxtVC = nxtNVC.topViewController as! EditDetailViewController
            nxtVC.dataSource = self
            self.editType = "Example"
            self.present( nxtNVC, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.definitionTable{
            if let rowNumber = self.definitions?.count{
                if self.definitionOnScreen.count > 0{
                    return self.definitionOnScreen.count
                }
                else{
                    return rowNumber
                }
            }
            else{
                return 1
            }
        }
        else{
            if let rowNumber = self.examples?.count{
                if self.exampleOnScreen.count > 0{
                    return self.exampleOnScreen.count
                }
                else{
                    return rowNumber
                }
            }
            else{
                return 1
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if tableView == self.definitionTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteDefinitionTableViewCell") as! NoteDefinitionTableViewCell
            if self.definitionOnScreen.count > 0{
                cell.textLabel?.text = self.definitionOnScreen[indexPath.row]
            }
            else{
                cell.textLabel?.text = self.word?.definition[0]
            }
            
            return cell
        }
         else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteExampleTableViewCell") as! NoteExampleTableViewCell
            if self.exampleOnScreen.count > 0{
                cell.textLabel?.text = self.exampleOnScreen[indexPath.row]
            }
            else{
                cell.textLabel?.text = self.word?.definition[0]
            }
            
            return cell
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
    @IBAction func onEditSynonym(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "EditDetailNavController") as! UINavigationController
        let nxtVC = nxtNVC.topViewController as! EditDetailViewController
        nxtVC.dataSource = self
        self.editType = "Synonym"
        self.present( nxtNVC, animated: true, completion: nil)
    }
    @IBAction func onEditAntonym(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "EditDetailNavController") as! UINavigationController
        let nxtVC = nxtNVC.topViewController as! EditDetailViewController
        nxtVC.dataSource = self
        self.editType = "Antonym"
        self.present( nxtNVC, animated: true, completion: nil)
    }
    
    
   
    
    
    
    func editDetailViewControllerGetSynonym() -> String {
        return self.Synonym.text!
    }
    func editDetailViewControllerGetAntonym() -> String {
        return self.Antonym.text!
    }
    func editDetailViewControllerGetExample() -> [String] {
        return self.examples!
    }
    func editDetailViewControllerGetEditType() -> String {
        return self.editType!
    }
    func editDetailViewControllerGetWord() -> String{
        return self.wordText.text!
    }
    func editDetailViewControllerGetDefinition() -> [String]{
        return self.definitions!
    }
    func editDetailViewControllerGetDisplayList() -> [Bool]{
        return self.definitionsToDisplay!
    }
    func editDetailViewControllerGetExampleDisplayList() -> [Bool]{
        return self.examplesToDisplay!
    }
        
    
    
    
}

