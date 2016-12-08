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
import AVFoundation
import MobileCoreServices
import Photos


class HomeTabBarController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var movieCount = Int()

    var word: Word?
    var menuButton: UIButton?
    
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
        
        let vc3 = storyboardM.instantiateViewController(withIdentifier: "HomeScreen") as! UIViewController
        //vc3.tabBarItem.image = UIImage(named: "addButton")?.imageWithRenderingMode.(UIImageRenderingModeAlwaysOriginal)
        //let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "addButton2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "addButton2"))
        //vc3.tabBarItem = customTabBarItem
        
        //vc3.tabBarItem.selectedImage
        
        let vc4 = storyboardM.instantiateViewController(withIdentifier: "HomeScreen") as! UIViewController
        vc4.tabBarItem.title = ""
        vc4.tabBarItem.image = UIImage(named: "notifications")
        
        let vc5 = storyboardM.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController  
        vc5.tabBarItem.title = ""
        vc5.tabBarItem.image = UIImage(named: "profile")

        
        // Set up the Tab Bar Controller to have four tabs
        
        self.viewControllers = [vc1, vc2, vc3, vc4, vc5]
    
        
        FirebaseClient.sharedInstance.fetchMoviePosts { (urlArray) in
            self.movieCount = (urlArray?.count)!
        }
        

        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMiddleButton()
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self.viewControllers?[1]{
            self.tabBar.isHidden = true
            self.menuButton?.isHidden = true
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabBarControllerDidSelect"), object: self)
        
    }
    
    
    func setupMiddleButton() {
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        var menuButtonFrame = menuButton?.frame
        menuButtonFrame?.origin.y = self.view.bounds.height - (menuButtonFrame?.height)!
        menuButtonFrame?.origin.x = self.view.bounds.width/2 - (menuButtonFrame?.size.width)!/2
        menuButton?.frame = menuButtonFrame!
        
        menuButton?.layer.cornerRadius = (menuButtonFrame?.height)!/2
        view.addSubview(menuButton!)
        menuButton?.addTarget(self, action: #selector(self.presentCameraPicker), for: UIControlEvents.touchUpInside)
        
        menuButton?.setImage(#imageLiteral(resourceName: "addButton2"),for: UIControlState.normal)
        
        //menuButton.isHidden = true
        
    }
    
    func presentCameraPicker()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.videoQuality = .typeLow
//        imagePicker.videoQuality = UIImagePickerControllerQualityType.typeIFrame960x540//typeIFrame1280x720
        imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
        imagePicker.videoQuality = .typeLow
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabBarControllerDidSelect"), object: self)

        
        present(imagePicker, animated: true, completion:nil)
    }
 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let url = info[UIImagePickerControllerMediaURL] as! URL
        
        
        self.dismiss(animated: true, completion: nil)
        let nxtVC = UserInputViewController.instantiateCustom(movieURL: url, count: movieCount)
        self.present( nxtVC, animated: true, completion:nil)

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url )
            
        }, completionHandler:nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }

    
   
    
}
