//
//  SearchTabViewController.swift
//  Wordie
//
//  Created by Lu Ao on 11/20/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase
import AFNetworking



class SearchTabViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    
    var word: Word?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let tabBar = self.tabBar
        tabBar.barTintColor = UIColor.clear
        tabBar.tintColor = UIColor.white
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = #imageLiteral(resourceName: "Line")

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Set up the first View Controller
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as! UINavigationController
        vc1.delegate = self
        vc1.tabBarItem.title = "Add Word"
        vc1.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.bookmarks, tag: 0)
        
        // Set up the second View Controller
        let vc2 = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as! UINavigationController
        vc2.delegate = self
        vc2.tabBarItem.title = "Word Set"
        vc2.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.history, tag: 1)
        
        let vc3 = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as! UINavigationController
        vc3.delegate = self
        vc3.tabBarItem.title = "Media"
        vc3.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.favorites, tag: 2)
        
        let vc4 = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as! UINavigationController
        vc4.delegate = self
        vc4.tabBarItem.title = "Personal"
        vc4.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.more, tag: 3)
        
        
        
        // Set up the Tab Bar Controller to have four tabs
        
        self.viewControllers = [vc1, vc2, vc3, vc4]
        
    }
    
    
}
