//
//  EditDetailViewController.swift
//  Wordie
//
//  Created by Lu Ao on 11/28/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//
//  Update word in user profile
//  Make Every info of a word arrays

import UIKit
import Firebase

@objc protocol EditDetailViewControllerDataSource {
    @objc func editDetailViewControllerGetWord() -> String
    @objc func editDetailViewControllerGetDefinition() -> [String]
    @objc func editDetailViewControllerGetEditType() -> String
    @objc func editDetailViewControllerGetSynonym() -> [String]
    @objc func editDetailViewControllerGetAntonym() -> [String]
    @objc func editDetailViewControllerGetExample() -> [String]
    @objc func editDetailViewControllerGetDisplayList() -> [Bool]
    @objc func editDetailViewControllerGetExampleDisplayList() -> [Bool]
    @objc func editDetailViewControllerGetSynonymDisplayList() -> [Bool]
    @objc func editDetailViewControllerGetAntonymDisplayList() -> [Bool]
}

class EditDetailViewController: UIViewController,UITextViewDelegate, UITableViewDataSource,UITableViewDelegate,EditDetailTableViewCellDelegate {

    var dataSource: EditDetailViewControllerDataSource?
    var definition: String?
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var editDetailTable: UITableView!
    
    var rowNumber = Int()
    
    
    var definitions: [String]?
    var examples: [String]?
    var synonyms: [String]?
    var antonyms: [String]?
    var editType: String?
    var displayList: [Bool]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editDetailTable.delegate = self
        self.editDetailTable.dataSource = self
        self.editDetailTable.estimatedRowHeight = 400
        self.editDetailTable.rowHeight = UITableViewAutomaticDimension
        self.word.text = self.dataSource?.editDetailViewControllerGetWord()
        self.editType = self.dataSource?.editDetailViewControllerGetEditType()
        
        switch  editType!{
            case "Definition":
                if let definitions = self.dataSource?.editDetailViewControllerGetDefinition(){
                    self.definitions = definitions
                }
                if let displayList = self.dataSource?.editDetailViewControllerGetDisplayList(){
                    self.displayList = displayList
                }
                self.rowNumber = (self.definitions?.count)!
                self.type.text = "Definition:"
            case "Example":
                if let examples = self.dataSource?.editDetailViewControllerGetExample(){
                    self.examples = examples
                }
                if let displayList = self.dataSource?.editDetailViewControllerGetExampleDisplayList(){
                    self.displayList = displayList
                }
                self.rowNumber = (self.examples?.count)!
                self.type.text = "Example:"
            case "Synonym":
                if let synonym = self.dataSource?.editDetailViewControllerGetSynonym(){
                    self.synonyms = synonym
                }
                if let displayList = self.dataSource?.editDetailViewControllerGetSynonymDisplayList(){
                    if (self.synonyms?.count)! > displayList.count{
                        var displayListTemp = [Bool]()
                        for _ in self.synonyms!{
                            displayListTemp.append(true)
                        }
                        self.displayList = displayListTemp
                    }
                    else{
                        self.displayList = displayList
                    }
                    
                }
                self.rowNumber = (self.synonyms?.count)!
                self.type.text = "Synonym:"
            case "Antonym":
                //self.definitionTextfield.text = self.dataSource?.editDetailViewControllerGetAntonym()
                if let antonym = self.dataSource?.editDetailViewControllerGetAntonym(){
                    self.antonyms = antonym
                }
                if let displayList = self.dataSource?.editDetailViewControllerGetAntonymDisplayList(){
                    if (self.antonyms?.count)! > displayList.count{
                        var displayListTemp = [Bool]()
                        for _ in self.antonyms!{
                            displayListTemp.append(true)
                        }
                        self.displayList = displayListTemp
                    }
                    else{
                        self.displayList = displayList
                    }
                }
                self.rowNumber = (self.antonyms?.count)!
                self.type.text = "Antonym:"
            default : print("It is empty")
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditDetailTableViewCell") as! EditDetailTableViewCell
        cell.delegate = self
        switch  self.editType!{
            
        case "Definition":
            if let definitions = self.definitions{
                if indexPath.row < definitions.count{
                    cell.detailEditField.text = definitions[indexPath.row]
                    if let displayOn = self.displayList?[indexPath.row]{
                        cell.radioButton.isSelected = displayOn
                    }

                }
                else{
                    
                    cell.radioButton.isSelected = true
                    cell.detailEditField.text = ""
                }
            }
        case "Example":
            if let examples = self.examples{
                if indexPath.row < examples.count{
                    cell.detailEditField.text = examples[indexPath.row]
                    if let displayOn = self.displayList?[indexPath.row]{
                        cell.radioButton.isSelected = displayOn
                    }
                    
                }
                else{
                    
                    cell.radioButton.isSelected = true
                    cell.detailEditField.text = ""
                }
            }
        case "Synonym":
            if let synonyms = self.synonyms{
                if indexPath.row < synonyms.count{
                    cell.detailEditField.text = synonyms[indexPath.row]
                    if let displayOn = self.displayList?[indexPath.row]{
                        cell.radioButton.isSelected = displayOn
                    }
                }
                else{
                    
                    cell.radioButton.isSelected = true
                    cell.detailEditField.text = ""
                }
            }
        case "Antonym":
            if let antonyms = self.antonyms{
                if indexPath.row < antonyms.count{
                    cell.detailEditField.text = antonyms[indexPath.row]
                    if let displayOn = self.displayList?[indexPath.row]{//index out of range
                        cell.radioButton.isSelected = displayOn
                    }
                }
                else{
                    
                    cell.radioButton.isSelected = true
                    cell.detailEditField.text = ""
                }
            }
        default :
            if let definitions = self.dataSource?.editDetailViewControllerGetDefinition(){
                cell.detailEditField.text = definitions[indexPath.row]
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.rowNumber > 0{
            return self.rowNumber
        }
        else{
            return 0
        }
    }
    @IBAction func onAddNew(_ sender: Any) {
        self.rowNumber+=1
        self.editDetailTable.reloadData()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func editDetailTableViewCellGiveIdxNMessage(indexPath: IndexPath, text: String, selected:Bool) {
        
        let editType = self.dataSource?.editDetailViewControllerGetEditType()
        switch  editType!{
            
        case "Definition":
            if indexPath.row < (self.definitions?.count)!{
                self.definitions?[indexPath.row] = text
                self.displayList?[indexPath.row] = selected
            }
            else{
                self.definitions?.append(text)
                self.displayList?.append(selected)
            }
            FirebaseClient.sharedInstance.addDefinitionToWord(word: self.word.text!, definition: self.definitions!, complete: {(newDefinition) in
            })
            FirebaseClient.sharedInstance.addDefinitionDisplyList(word: self.word.text!, displayList: self.displayList!, complete: {(newDisplayList) in
            })
        case "Example":
            if indexPath.row < (self.examples?.count)!{
                self.examples?[indexPath.row] = text
                self.displayList?[indexPath.row] = selected
            }
            else{
                self.examples?.append(text)
                self.displayList?.append(selected)
            }
            FirebaseClient.sharedInstance.addExampleToWord(word: self.word.text!, example: self.examples!, complete: {(newDefinition) in
            })
            FirebaseClient.sharedInstance.addExampleDisplyList(word: self.word.text!, displayList: self.displayList!, complete: {(newDisplayList) in
            })
        case "Synonym":
            if indexPath.row < (self.synonyms?.count)!{
                self.synonyms?[indexPath.row] = text
                self.displayList?[indexPath.row] = selected
            }
            else{
                self.synonyms?.append(text)
                self.displayList?.append(selected)
            }
            FirebaseClient.sharedInstance.addSynonymToWord(word: self.word.text!, synonym: self.synonyms!, complete: {(newDefinition) in
            })
            FirebaseClient.sharedInstance.addSynonymDisplyList(word: self.word.text!, displayList: self.displayList!, complete:{(newDisplayList) in
            })

        case "Antonym":
            if indexPath.row < (self.antonyms?.count)!{
                self.antonyms?[indexPath.row] = text
                self.displayList?[indexPath.row] = selected
            }
            else{
                self.antonyms?.append(text)
                self.displayList?.append(selected)
            }
            FirebaseClient.sharedInstance.addAntonymToWord(word: self.word.text!, antonym: self.antonyms!, complete: {(newDefinition) in
            })
            FirebaseClient.sharedInstance.addAntonymDisplyList(word: self.word.text!, displayList: self.displayList!, complete:{(newDisplayList) in
            })
        default : self.dismiss(animated: true, completion: nil)
        }
        
    }
}

