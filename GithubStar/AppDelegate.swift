//
//  AppDelegate.swift
//  GITStare
//
//  Created by xiaolei on 15/11/23.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import OAuthSwift
//import RealmSwift
//全局变量 realm   默认数据库
//let realm = try! Realm()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow()
        let rootview = RootTabBarViewController()        
        window!.rootViewController = rootview
        window!.makeKeyAndVisible()
        
        ConnectingDataBase.sharedObject.db
        
        StarSQLiteModel.createTable()
        TrendingStarSQLiteModel.createTable()
        StarReadMeSQLite.createTable()
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
  
        
    }
    
    
}

