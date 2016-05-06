//
//  AppDelegate.swift
//  GITStare
//
//  Created by xiaolei on 15/11/23.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import OAuthSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow()
        let rootview = RootTabBarViewController()        
        window!.rootViewController = rootview
        window!.makeKeyAndVisible()

        
        return true
    }
    

    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if url.host == "oauth-callback"{
            if url.path!.hasPrefix("/github"){
             OAuth2Swift.handleOpenURL(url)
            }
        }
        return true
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
       
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
  
    }
    
    
}

