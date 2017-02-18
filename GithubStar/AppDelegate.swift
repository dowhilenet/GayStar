//
//  AppDelegate.swift
//  GITStare
//
//  Created by xiaolei on 15/11/23.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import SwiftyOAuth

let github = Provider.gitHub(clientID: "af3689b7eef793657839", clientSecret: "b2f4713ee30029079d036428f0ed45c6b44982a2", redirectURL: "GITStare://callback")
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: Any]?) -> Bool {
      
        self.window = UIWindow()
        let rootview = UIViewController()
        self.window!.rootViewController = rootview
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        
//        github.authorize { (result) in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let value):
//                print(value.accessToken)
//            }
//        }
        
        return true
    }
    

//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        github.handleURL(url, options: options)
//        return true
//    }
    
    
    
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

