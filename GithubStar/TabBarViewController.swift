//
//  TabBarViewController.swift
//  GithubStar
//
//  Created by xiaolei on 2017/1/2.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let timeLineVC = TimeLineViewController()
        timeLineVC.tabBarItem.title = "时间线"
        let timeLine = TimeLineViewController()
        timeLine.tabBarItem.title = "时间线2"
        viewControllers = [timeLineVC,timeLine]
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
