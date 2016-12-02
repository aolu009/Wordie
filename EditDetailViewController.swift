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
    @objc func editDetailViewControllerGetSynonym() -> String
    @objc func editDetailViewControllerGetAntonym() -> String
    @objc func editDetailViewControllerGetExample() -> [String]
    @objc func editDetailViewControllerGetDisplayList() -> [Bool]
    @objc func editDetailViewControllerGetExampleDisplayList() -> [Bool]
}

class EditDetailViewController: UIViewController,UITextViewDelegate, UITableViewDataSource,UITableViewDelegate,EditDetailTableViewCellDelegate {

    var dataSource: EditDetailViewControllerDataSource?
    var definition: String?
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var definitionTextfield: UITextView!
    
    @IBOutlet weak var editDetailTable: UITableView!
    
    
    var definitions: [String]?
    var examples: [String]?
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
                self.type.text = "Definition:"
            case "Example":
                if let examples = self.dataSource?.editDetailViewControllerGetExample(){
                    self.examples = examples
                }
                if let displayList = self.dataSource?.editDetailViewControllerGetExampleDisplayList(){
                    self.displayList = displayList
                }
                self.type.text = "Example:"
            case "Synonym":
                self.definitionTextfield.text = self.dataSource?.editDetailViewControllerGetSynonym()
                self.type.text = "Synonym:"
            case "Antonym":
                self.definitionTextfield.text = self.dataSource?.editDetailViewControllerGetAntonym()
                self.type.text = "Antonym:"
            default : self.definitionTextfield.text = "It is empty"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.definition = textView.text
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
                cell.detailEditField.text = examples[indexPath.row]
                if let displayOn = self.displayList?[indexPath.row]{
                    cell.radioButton.isSelected = displayOn
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
        
        switch  self.editType!{
            
        case "Definition":
            
            if let definitions = self.dataSource?.editDetailViewControllerGetDefinition(){
                return (definitions.count + 1)
            }
            else{
                return 0
            }
        case "Example":
            if let examples = self.dataSource?.editDetailViewControllerGetExample(){
                return examples.count
            }
            else{
                return 0
            }
        case "Synonym":
            self.definitionTextfield.text = self.dataSource?.editDetailViewControllerGetSynonym()
            self.type.text = "Synonym:"
            return 0
        case "Antonym":
            self.definitionTextfield.text = self.dataSource?.editDetailViewControllerGetAntonym()
            self.type.text = "Antonym:"
            return 0
        default : return 0
        }
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
                //if select = select
                print("Select:",selected)
                self.displayList?.append(selected)
                print("Select:",self.displayList?.count)
            }
            FirebaseClient.sharedInstance.addDefinitionToWord(word: self.word.text!, definition: self.definitions!,displayList: self.displayList!, complete: {(newDefinition, newDisplayList) in
                print("Select.size:",newDisplayList?.count)
            })
        case "Example":
            self.examples?[indexPath.row] = text
            self.displayList?[indexPath.row] = selected
            FirebaseClient.sharedInstance.addExampleToWord(word: self.word.text!, example: self.examples!,displayList: self.displayList! , complete: {(newDefinition) in
            })
        case "Synonym":
            FirebaseClient.sharedInstance.addSynonymToWord(word: self.word.text!, synonym: self.definition!, complete: {(newDefinition) in
            })
        case "Antonym":
            FirebaseClient.sharedInstance.addAntonymToWord(word: self.word.text!, antonym: self.definition!, complete: {(newDefinition) in
            })
        default : self.dismiss(animated: true, completion: nil)
        }
        
    }
}

