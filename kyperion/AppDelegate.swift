//
//  AppDelegate.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        initUser()
        customizeAppearance()
        
        return true
    }

    func initUser(){
        
        if tokenUser != "" {
            var user = KYUser()
            user.setLogin(username: usernameLoggin, password: passwordLoggin, token:tokenUser)
            currentUser = user
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("rootViewController") as! RootViewController
            
            /*
            if DEBUG_MOD_TEST {
                storyboard = UIStoryboard(name: "MainTest", bundle: nil)
                initialViewController = storyboard.instantiateViewControllerWithIdentifier("mainTestViewController") as! MainTestViewController
            }
            */
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    
    }
    
    func customizeAppearance()
    {
        let titleFont : UIFont = UIFont(name: FONT_HELVETICA_NEUE, size: 16.0)!
        let attributes = [
            NSFontAttributeName : titleFont,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().backgroundColor = UIColor.mainAppColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.mainAppColor()
        
        //UITabBar.appearance().backgroundColor = UIColor.mainAppColor()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //KYCoreDataStack.sharedManager.saveContext();
    }

}

