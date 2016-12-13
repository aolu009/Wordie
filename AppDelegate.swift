//
//  AppDelegate.swift
//  Dictionary
//
//  Created by Lu Ao on 11/13/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UINavigationControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Connect Firebase
        FIRApp.configure()
        
        UIApplication.shared.statusBarStyle = .lightContent

        
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        tabBar.tintColor = UIColor.white
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = #imageLiteral(resourceName: "Line")
        
        UITextField.appearance().tintColor = UIColor.green
        UINavigationBar.appearance().tintColor = UIColor.green

        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            self.showHomeScreen()
        } else {
            // No user is signed in.
            self.showWelcome()
        }
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func showHomeScreen()
    {
        let storyboard = UIStoryboard.init(name: "Malcolm.Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
        
    }

    func showWelcome()
    {
        print("No current user logged in yet")
        
        let storyboard = UIStoryboard.init(name: "Malcolm.Main", bundle: nil)
        
        let loginVC = storyboard.instantiateViewController(withIdentifier: "WelcomeNav") as! UINavigationController
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
        
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
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)

    }


}

