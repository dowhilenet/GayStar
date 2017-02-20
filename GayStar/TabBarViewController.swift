//
//  TabBarViewController.swift
//  GayStar
//
//  Created by xiaolei on 2017/1/7.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let oneNav = UINavigationController(rootViewController: TimeLineViewController())
        let oneVC = oneNav
        oneVC.tabBarItem.title = "TimeLine"
      
        let twoNav = UINavigationController(rootViewController: TrendingPageViewController())
        let twoVC = twoNav
        twoVC.tabBarItem.title = "Two"
      
        let threeNav = UINavigationController(rootViewController: StarRepoViewController())
        let threeVC = threeNav
        threeVC.tabBarItem.title = "Three"
        viewControllers = [oneVC,twoVC,threeVC]
        
    }
}
