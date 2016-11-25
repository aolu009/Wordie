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
        //Connect Firebase
        FIRApp.configure()
        
        
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = #imageLiteral(resourceName: "Line")
        
        
        if LoginViewController.currentUser != nil
        {
            //we have a current user, show them loading then tweets view
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let loadingVC = storyboard.instantiateViewController(withIdentifier: "TRLoadingViewController") as! TRLoadingViewController
            
            if let currentUser = TRUser.currentUser {
                print("User already logged in: \(currentUser.name)")
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = loadingVC
                window?.makeKeyAndVisible()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // your code here
                    self.animateTwitterFeedWithHamburgerMenu()
                }
                
            }
        }
        else{
            print("No current user logged in yet")
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let loginVC = storyboard.instantiateViewController(withIdentifier: "TRLoginViewController") as! TRLoginViewController
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = loginVC
            window?.makeKeyAndVisible()
            
        }
        
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

