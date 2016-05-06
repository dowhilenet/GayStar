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
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
       //配置 TabBar 样式
        UITabBar.appearance().translucent = true
        UITabBar.appearance().tintColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
//        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        
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
        
        let thirdViewController = UINavigationController(rootViewController: PageMenuViewController())
        
        let thirdTabBarItem = UITabBarItem()
        thirdTabBarItem.title = "Trending"
        thirdTabBarItem.image = UIImage(named: "Oval 32")
        thirdViewController.tabBarItem = thirdTabBarItem
        
        
        //4
        let fourViewController = UINavigationController(rootViewController: ChooseChatRoomTableViewController())
        let fourTabBarItem = UITabBarItem()
        fourTabBarItem.title = "Chat"
        fourViewController.tabBarItem = fourTabBarItem
        
        //5
        let layout = UICollectionViewFlowLayout()
        let fiveViewController = UINavigationController(rootViewController: TagCollectionViewController(collectionViewLayout: layout))
        let fiveTabBarItem = UITabBarItem()
        fiveTabBarItem.title = "Cool"
        fiveViewController.tabBarItem = fiveTabBarItem
        self.viewControllers = [firstViewController,secViewController,thirdViewController,fourViewController,fiveViewController]


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}


