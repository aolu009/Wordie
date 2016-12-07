//
//  DefinitionTabViewController.swift
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

protocol DefinitionTabViewControllerDataSource {
    func definitionTabViewController() -> Word
}


class DefinitionTabViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate/*,WordDetailViewControllerDataSource, NoteViewControllerDataSource*/ {
    
    
    var word: Word?
    var dataSource: DefinitionTabViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Set up the first View Controller
         let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        
         let vc1 = storyboard.instantiateViewController(withIdentifier: "WordDetailNavController") as! UINavigationController
         let vc1top = vc1.topViewController as! WordDetailViewController
         vc1top.word = self.dataSource?.definitionTabViewController()
         vc1.delegate = self
         vc1.tabBarItem.title = "Definition"
         vc1.tabBarItem.image = UIImage(named: "Definition")
         //vc1.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.bookmarks, tag: 0)
         
         // Set up the second View Controller
         let vc2 = storyboard.instantiateViewController(withIdentifier: "NoteNavController") as! UINavigationController
         let vc2top = vc2.topViewController as! NoteViewController
         vc2top.word = self.dataSource?.definitionTabViewController()
         vc2.delegate = self
         vc2.tabBarItem.title = "Note"
         vc2.tabBarItem.image = UIImage(named: "Note")
         //vc2.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.history, tag: 1)
         
         let vc3 = storyboard.instantiateViewController(withIdentifier: "VideoForNoteNViewController") as! UINavigationController
         let vc3top = vc3.topViewController as! VideoForNoteViewController
         vc3top.word = self.dataSource?.definitionTabViewController().word
        print("OMGGG:",self.dataSource?.definitionTabViewController().word)
         vc3top.pronounce = self.dataSource?.definitionTabViewController().audiourl[0]
        print("OMGGG:",self.dataSource?.definitionTabViewController().audiourl[0])
         vc3.delegate = self
         vc3.tabBarItem.title = "Video"
         //vc3.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.favorites, tag: 2)
         vc3.tabBarItem.image = UIImage(named: "NoteVideo")
         
         self.viewControllers = [vc1, vc2, vc3]
        
    }
    
    

    /*
    func wordDetailViewController() -> Word {
        return (self.dataSource?.definitionTabViewController())!
    }
    func noteViewController() -> Word {
        return (self.dataSource?.definitionTabViewController())!
    }*/
}
