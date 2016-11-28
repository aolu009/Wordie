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
        
        
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = #imageLiteral(resourceName: "Line")
        
        let user = FIRAuth.auth()?.currentUser
//        UserDefaults.standard.setValue(self.currentUserID, forKey: "uid")
        
        let facebookDefaults =  UserDefaults.standard.value(forKey: "facebook") as! Bool

        
        if facebookDefaults == true {
            
            if let decodedNSDataBlob = UserDefaults.standard.object(forKey: "credential") as? NSData
            {
                let credential = NSKeyedUnarchiver.unarchiveObject(with: decodedNSDataBlob as Data) as? FIRAuthCredential
                
                FIRAuth.auth()?.signIn(with: credential!) { (user, error) in
                    // ...
                    if let error = error {
                        // ...
                        return
                    }
                }
 
            }
            

            
        }
        else if facebookDefaults == false {
            
            let email =  UserDefaults.standard.value(forKey: "email") as! String
            let password =  UserDefaults.standard.value(forKey: "password") as! String
            
            FIRAuth.auth()!.signIn(withEmail: email,
                                   password: password)
            
        }
        else{
            
        }



        
        if user != nil
        {
            //we have a current user, show them home screen
            let storyboard = UIStoryboard.init(name: "Malcolm.Main", bundle: nil)
            
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
            
            if let currentUser = user {
                print("User already logged in: \(currentUser.uid)")
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = homeVC
                window?.makeKeyAndVisible()
                
            }
        }
        else{
            print("No current user logged in yet")
            
            let storyboard = UIStoryboard.init(name: "Malcolm.Main", bundle: nil)
            
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = loginVC
            window?.makeKeyAndVisible()
            
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
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
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }



}

