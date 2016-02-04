//
//  PageMenuViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/4.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import PageMenuFramework


class PageMenuViewController: UIViewController , CAPSPageMenuDelegate{

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageMenuConfig()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageMenuConfig(){
        
        self.title = "Trending"
        
        var controllerArray = [UIViewController]()
        
        let today = TodyViewController()
        today.title = "Today"
        controllerArray.append(today)
        
        let week = TodyViewController()
        week.title = "Week"
        controllerArray.append(week)
        
        let month = TodyViewController()
        month.title = "Month"
        controllerArray.append(month)
        
        let parameters: [CAPSPageMenuOption] = [
            //分离器的宽度
            .MenuItemSeparatorWidth(4.3),
            //是否使用Segment模式
            .UseMenuLikeSegmentedControl(true),
            //分离器的高度
            .MenuItemSeparatorPercentageHeight(0.1),
            //分离器变成小圆点
            .MenuItemSeparatorRoundEdges(true),
            //背景颜色
            .ViewBackgroundColor(UIColor.blackColor()),
            //Menu 背景颜色
            .ScrollMenuBackgroundColor(UIColor.blackColor()),
            //横向滚动条的颜色
            .SelectionIndicatorColor(UIColor.orangeColor()),
            //选中的Menu文字颜色
            .SelectedMenuItemLabelColor(UIColor.whiteColor()),
            //未选中Menu文字颜色
//            .UnselectedMenuItemLabelColor(UIColor(red:0.837, green:0.837, blue:0.837, alpha:1)),
            //Menu 之间的空隙颜色
            .MenuItemSeparatorColor(UIColor.whiteColor()),
            //横向滚动轨道颜色
            .BottomMenuHairlineColor(UIColor.blackColor()),
            .MenuItemFont(UIFont(name: "OpenSans-Italic", size: 14)!),
            .EnableHorizontalBounce(true),
            .MenuItemWidthBasedOnTitleTextWidth(true)
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.delegate = self
    }

}
