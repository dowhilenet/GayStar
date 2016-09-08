//
//  AppDelegate.swift
//  GITStare
//
//  Created by xiaolei on 15/11/23.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: Any]?) -> Bool {
        
        window = UIWindow()
        let rootview = RootTabBarViewController()        
        window!.rootViewController = rootview
        window!.makeKeyAndVisible()

        
        return true
    }
    

    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.host == "oauth-callback"{
            if url.path.hasPrefix("/github"){
             OAuth2Swift.handleOpenURL(url)
            }
        }
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
  
    }
    
    
}

