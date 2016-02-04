//
//  RootTabBarViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/22.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
class RootTabBarViewController: UITabBarController {
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //配置 nav 样式
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().translucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
       //配置 TabBar 样式
//        UITabBar.appearance().translucent = true
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        
        //1
        let firstViewController = UINavigationController(rootViewController: StarsTableViewController())
        firstViewController.navigationBar.barStyle = .Black
        let firstViewTabBarItem = UITabBarItem()
        firstViewTabBarItem.title = "Star"
        firstViewTabBarItem.image = UIImage(named: "Star 3")
        firstViewController.tabBarItem = firstViewTabBarItem
        
        //2
        let secViewController = UINavigationController(rootViewController: ReferenceTableViewController())
        secViewController.navigationBar.barStyle = .Black
        let secTabBarItem = UITabBarItem()
        secTabBarItem.title = "Group"
        secTabBarItem.image = UIImage(named: "Oval 13")
        secViewController.tabBarItem = secTabBarItem
        
        //3
        self.viewControllers = [firstViewController,secViewController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}


