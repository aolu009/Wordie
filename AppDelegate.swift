//
//  AppDelegate.swift
//  Dictionary
//
//  Created by Lu Ao on 11/13/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UINavigationControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        //Connect Firebase
        FIRApp.configure()
        
        
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
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [vc1, vc2, vc3, vc4]
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

