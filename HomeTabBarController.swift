//
//  HomeTabBarController.swift
//  Wordie
//
//  Created by Lu Ao on 11/21/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase
import AFNetworking



class HomeTabBarController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    
    var word: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Set up the first View Controller
        let storyboardM = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let vc1 = storyboardM.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //vc1.tabBarItem.title = "Add Word"
        //vc1.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.bookmarks, tag: 0)
        vc1.tabBarItem.image = UIImage(named: "home")
        
        // Set up the second View Controller
        let storyboard = UIStoryboard(name: "Louis.Main", bundle: nil)
        let vc2 = storyboard.instantiateViewController(withIdentifier: "SearchTabViewController") as! SearchTabViewController
        //vc2.delegate = self
        vc2.tabBarItem.title = ""
        //vc2.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.history, tag: 1)
        vc2.tabBarItem.image = UIImage(named: "search")
        
        let vc3 = storyboardM.instantiateViewController(withIdentifier: "CameraPickerController") as! CameraPickerController
        vc3.tabBarItem.image = UIImage(named: "addButton")
        //vc3.tabBarItem.selectedImage
        
        let vc4 = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as! UINavigationController
        vc4.delegate = self
        vc4.tabBarItem.title = ""
        vc4.tabBarItem.image = UIImage(named: "notifications")
        
        let vc5 = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as! UINavigationController
        vc5.delegate = self
        vc5.tabBarItem.title = ""
        vc5.tabBarItem.image = UIImage(named: "profile")

        
        // Set up the Tab Bar Controller to have four tabs
        
        self.viewControllers = [vc1, vc2, vc3, vc4, vc5]
        
        setupMiddleButton()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectedIndex = 0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self.viewControllers?[1]{
            self.tabBar.isHidden = true
            
                    }
        
    }
    
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        menuButton.addTarget(self, action: #selector(self.presentCameraPicker), for: UIControlEvents.touchUpInside)
        
        menuButton.setImage(#imageLiteral(resourceName: "addButton"),
                            for: UIControlState.normal)
    }
    
    func presentCameraPicker()
    {
        let storyboard = UIStoryboard(name: "Malcolm.Main", bundle: nil)
        let nxtNVC = storyboard.instantiateViewController(withIdentifier: "CameraPickerController") as! CameraPickerController
        self.present( nxtNVC, animated: true, completion: nil)
    }
 
    

    
   
    
}
