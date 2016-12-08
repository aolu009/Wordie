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
import AVFoundation

@objc protocol NoteViewControllerDataSource {
    @objc optional func noteViewController() -> Word
    @objc optional func noteViewControllerDefinition() -> String
}

class NoteViewController: UIViewController, EditDetailViewControllerDataSource,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var exampleTable: UITableView!
    @IBOutlet weak var definitionTable: UITableView!
    @IBOutlet weak var synonymTable: UITableView!
    @IBOutlet weak var antonymTable: UITableView!
    @IBOutlet weak var pronounceButton: UIButton!
    @IBOutlet weak var buttonOutlet: UIView!
    @IBOutlet weak var wordText: UILabel!
    
    
    var dataSource: NoteViewControllerDataSource?
    var word: Word?
    var editType:String?
    var definitions: [String]?
    var definitionsToDisplay: [Bool]?
    var definitionOnScreen = [String]()
    var examplesToDisplay: [Bool]?
    var examples: [String]?
    var exampleOnScreen = [String]()
    var synonymToDisplay: [Bool]?
    var synonymWord: [String]?
    var synonymOnScreen = [String]()
    var antonymToDisplay: [Bool]?
    var antonymWord: [String]?
    var antonymOnScreen = [String]()
    var soundUrl = String()
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definitionTable.delegate = self
        self.definitionTable.dataSource = self
        self.definitionTable.rowHeight = 20
        self.exampleTable.delegate = self
        self.exampleTable.dataSource = self
        self.exampleTable.rowHeight = 20
        self.synonymTable.delegate = self
        self.synonymTable.dataSource = self
        self.antonymTable.delegate = self
        self.antonymTable.dataSource = self
        self.antonymTable.estimatedRowHeight = 400
        self.antonymTable.rowHeight = UITableViewAutomaticDimension
        self.synonymTable.estimatedRowHeight = 400
        self.synonymTable.rowHeight = UITableViewAutomaticDimension
        //pronounceButton.backgroundColor = UIColor.white
        pronounceButton.layer.cornerRadius = 0.5 * pronounceButton.bounds.size.width
        pronounceButton.layer.borderColor = UIColor.black.cgColor
        buttonOutlet.layer.cornerRadius = 0.5 * buttonOutlet.bounds.size.width
        self.view.bringSubview(toFront: buttonOutlet)
        
        if let word = self.word{
            self.wordText.text = word.word
            
            self.soundUrl = word.audiourl[0]
            self.pronounceButton.setTitle(word.word, for: .normal)
        }
        else{
            print("Error:Nothing Passed to here")
        }
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
                self.definitionTable.reloadData()
            })
            FirebaseClient.sharedInstance.getDefinitionDisplayList(word: vocabulary, complete: {(definitionsToDisplay) in
                var idx = 0
                self.definitionOnScreen = [String]()
                
                for definition in self.definitions!{
                    if  (idx < (self.definitionsToDisplay?.count)! && (self.definitionsToDisplay?[idx])! == true){
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
            })
            FirebaseClient.sharedInstance.getExampleDisplayList(word: vocabulary, complete: {(examplesToDisplay) in
                var idx = 0
                self.exampleOnScreen = [String]()
                
                for example in self.examples!{
                    if  (idx < (self.examplesToDisplay?.count)! && (self.examplesToDisplay?[idx])! == true){
                        self.exampleOnScreen.append(example)
                    }
                    idx+=1
                }
                self.exampleTable.reloadData()
                
            })
            FirebaseClient.sharedInstance.getSelfDefinedSynonymOnWord(word: vocabulary, complete: {(synonyms,synonymToDisplay) in
                if let synonyms = synonyms{
                    if synonyms.count==0{
                        self.synonymWord = self.word?.synonym
                        print("Please Enter Synonyms here",synonyms)
                    }
                    else{
                        self.synonymWord = synonyms
                        print("Please Enter Synonyms",synonyms)
                    }
                    
                }
                else{
                    self.synonymWord = self.word?.synonym
                    print("Please Enter Synonym")
                }
                if let synonymToDisplay = synonymToDisplay{
                    self.synonymToDisplay = synonymToDisplay
                }
            })
            FirebaseClient.sharedInstance.getSynonymDisplayList(word: vocabulary, complete: {(synonymToDisplay) in
                if self.synonymWord != nil{
                    var idx = 0
                    self.synonymOnScreen = [String]()
                    for synonym in self.synonymWord!{
                        if  (idx < (self.synonymToDisplay?.count)! && (self.synonymToDisplay?[idx])! == true){
                            self.synonymOnScreen.append(synonym)
                        }
                        idx+=1
                    }
                }
                self.synonymTable.reloadData()
            })
            
            FirebaseClient.sharedInstance.getSelfDefinedAntonymOnWord(word: vocabulary, complete: {(antonyms,antonymToDisplay) in
                if let antonyms = antonyms {
                    if antonyms.count==0{
                        self.antonymWord = self.word?.antonym
                    }
                    else{
                        self.antonymWord = antonyms
                        print("Please Enter Antonym",antonyms)
                    }
                    
                }
                else{
                    
                    print("Please Enter Antonym")
                }
                if let antonymToDisplay = antonymToDisplay{
                    self.antonymToDisplay = antonymToDisplay
                }
            })
            FirebaseClient.sharedInstance.getAntonymDisplayList(word: vocabulary, complete: {(antonymToDisplay) in
                if self.antonymWord != nil{
                    var idx = 0
                    self.antonymOnScreen = [String]()
                    for antonym in self.antonymWord!{
                        if  (idx < (self.antonymToDisplay?.count)! && (self.antonymToDisplay?[idx])! == true){
                            self.antonymOnScreen.append(antonym)
                        }
                        idx+=1
                    }
                }
                
                self.antonymTable.reloadData()
            })
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "EditDetailNavController") as! UINavigationController
        let nxtVC = nxtNVC.topViewController as! EditDetailViewController
        nxtVC.dataSource = self
        if tableView == self.definitionTable{
            self.editType = "Definition"
            self.present( nxtNVC, animated: true, completion: nil)
        }
        else if tableView == self.exampleTable{
            self.editType = "Example"
            self.present( nxtNVC, animated: true, completion: nil)
        }
        else if tableView == self.synonymTable{
            self.editType = "Synonym"
            self.present( nxtNVC, animated: true, completion: nil)
        }
        else{
            self.editType = "Antonym"
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
                    if rowNumber == 0{
                        return 1
                    }
                    else{
                        return rowNumber
                    }
                }
            }
            else{
                return 1
            }
        }
        else if tableView == self.exampleTable{
            if let rowNumber = self.examples?.count{
                if self.exampleOnScreen.count > 0{
                    return self.exampleOnScreen.count
                }
                else{
                    if rowNumber == 0{
                        return 1
                    }
                    else{
                        return rowNumber
                    }
                }
            }
            else{
                return 1
            }
        }
        else if tableView == self.synonymTable{
            if let rowNumber = self.synonymWord?.count{
                if self.synonymOnScreen.count > 0{
                    return self.synonymOnScreen.count
                }
                else{
                    if rowNumber == 0{
                        return 1
                    }
                    else{
                        return rowNumber
                    }
                }
            }
            else{
                return 1
            }
        }
        else{
            if let rowNumber = self.antonymWord?.count{
                if self.antonymOnScreen.count > 0{
                    return self.antonymOnScreen.count
                }
                else{
                    if rowNumber == 0{
                        return 1
                    }
                    else{
                        return rowNumber
                    }
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
                cell.textLabel?.numberOfLines = 0
            }
            else{
                cell.textLabel?.text = self.word?.definition[0]
            }
            return cell
        }
         else if tableView == self.exampleTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteExampleTableViewCell") as! NoteExampleTableViewCell
            if self.exampleOnScreen.count > 0{
                cell.textLabel?.text = self.exampleOnScreen[indexPath.row]
                
            }
            else{
                cell.textLabel?.text = self.word?.definitionAndExample[(self.word?.definition[0])!]
            }
            
            return cell
        }
         else if tableView == self.synonymTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SynonymTableViewCell") as! SynonymTableViewCell
            if self.synonymOnScreen.count > 0{
                print("self.synonymOnScreen.count:",self.synonymOnScreen.count )
                cell.synonym?.text = self.synonymOnScreen[indexPath.row]
            }
            else{
                cell.synonym?.text = self.synonymWord?[indexPath.row]//"Tab here to add"
            }
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AntonymTableViewCell") as! AntonymTableViewCell
            if self.antonymOnScreen.count > 0{
                cell.antonym?.text = self.antonymOnScreen[indexPath.row]
            }
            else{
                cell.antonym?.text = self.antonymWord?[indexPath.row]//"Tab here to add"
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
    @IBAction func onPronounce(_ sender: Any) {
        
        play(url: self.soundUrl)
    }
    
    
    
    func editDetailViewControllerGetSynonym() -> [String] {
        return self.synonymWord!
    }
    func editDetailViewControllerGetAntonym() -> [String] {
        return self.antonymWord!
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
    func editDetailViewControllerGetSynonymDisplayList() -> [Bool]{
        return self.synonymToDisplay!
    }
    func editDetailViewControllerGetAntonymDisplayList() -> [Bool]{
        return self.antonymToDisplay!
    }
    
    func play(url:String) {  
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        do {
            
            let playerItem = AVPlayerItem(url: URL(string:url)!)
            self.player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
}

