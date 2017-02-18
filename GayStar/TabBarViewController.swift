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
        let oneVC = ViewController()
        oneVC.tabBarItem.title = "One"
        let twoVC = ViewController()
        twoVC.tabBarItem.title = "Two"
        let threeVC = ViewController()
        threeVC.tabBarItem.title = "Three"
        viewControllers = [oneVC,twoVC,threeVC]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
