//
//  WordDetailViewController.swift
//  Dictionary
//
//  Created by Lu Ao on 11/19/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//
//Got to step up container View
//
import UIKit
import Firebase
import AFNetworking

protocol WordDetailViewControllerDataSource {
    func wordDetailViewController() -> Word
}




class WordDetailViewController: UIViewController, UITabBarControllerDelegate, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var definitionTable: UITableView!
    var word: Word?
    var dataSource: WordDetailViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definitionTable.delegate = self
        definitionTable.dataSource = self
        definitionTable.estimatedRowHeight = 300
        definitionTable.rowHeight = UITableViewAutomaticDimension
        /*
        // checking if word info load properly
        if let word = self.word{ //dataSource?.wordDetailViewController()
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
        */
        definitionTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        else{
            return (word?.definition.count)!
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell") as! WordTableViewCell
            if let word = self.word{
                cell.word.text = word.word
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionTableViewCell") as! DefinitionTableViewCell
            if let word = self.word{
                cell.categoryText.text = word.categories[indexPath.row]
                cell.definitionText.text = word.definition[indexPath.row]
                cell.exampleText.text = "Example:\n" + word.definitionAndExample[word.definition[indexPath.row]]!
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @IBAction func onSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "SearchTabViewController") as! SearchTabViewController
        //let nxtVC = nxtNVC.topViewController as! EditDetailViewController
        //nxtVC.dataSource = self
        self.present( nxtNVC, animated: true, completion: {
            //self.dismiss(animated: true, completion: nil)
            
        })
        //self.dismiss(animated: true, completion: nil)
    }
    
}



