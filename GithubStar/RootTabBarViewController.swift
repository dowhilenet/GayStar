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
        self.view.backgroundColor = UIColor.whiteColor()
        //1
        let firstViewController = UINavigationController(rootViewController: StarsTableViewController())
        UINavigationBar.appearance().barTintColor = UIColor(red: 239.0/255.0, green: 95.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = true
        let firstViewTabBarItem = UITabBarItem()
        firstViewTabBarItem.title = "Stars"
        firstViewController.tabBarItem = firstViewTabBarItem
        //2
 
//        let secViewController = UINavigationController(rootViewController: TodyViewController())
//        
//        let secTabBarItem = UITabBarItem()
//        secTabBarItem.title = "Explore"
//        secViewController.tabBarItem = secTabBarItem
        
        //3
        
        self.viewControllers = [firstViewController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
