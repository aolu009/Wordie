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
    var storedOffsets = [Int: CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        definitionTable.delegate = self
        definitionTable.dataSource = self
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
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        else if section == 1{
            return (word?.definition.count)!
        }
        else {
            return 1
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
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionTableViewCell") as! DefinitionTableViewCell
            if let word = self.word{
                cell.categoryText.text = word.categories[indexPath.row]
                cell.definitionText.text = word.definition[indexPath.row]
                cell.exampleText.text = word.definitionAndExample[word.definition[indexPath.row]]
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableTableViewCell") as! SwipeableTableViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0

            return cell

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2{
            guard let tableViewCell = cell as? SwipeableTableViewCell else { return }
            
            storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
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
        //self.dismiss(animated: true, completion: nil)
    }
    
}


extension WordDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = UIColor.yellow
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
