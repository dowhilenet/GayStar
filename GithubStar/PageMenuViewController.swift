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
    var pageMenu1: CAPSPageMenu?
    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Trending", rightTitle: "Showcases")
    override func viewDidLoad() {
        super.viewDidLoad()
        pageMenuConfig()
        runkeepeSwitch()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     配置 switch
     */
    private func runkeepeSwitch(){
        runkeeperSwitch.backgroundColor = .blackColor()
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.tintColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = .blackColor()
        runkeeperSwitch.titleFont = UIFont(name: "OpenSans", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
        runkeeperSwitch.addTarget(self, action: Selector("switchValueDidChange:"), forControlEvents: .ValueChanged)
        self.navigationItem.titleView = runkeeperSwitch
    }
    
    /**
     根据选择显示数据
     
     - parameter sender: sender
     */
    func switchValueDidChange(sender:DGRunkeeperSwitch){
        if self.runkeeperSwitch.selectedIndex == 0{
            pageMenuConfig()
            pageMenu1 = nil
        }else{
            pageMenu1Config()
            pageMenu = nil
        }
    }
    
    
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
    
    func pageMenuConfig(){
        
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
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.delegate = self
    }
    
    
    func pageMenu1Config() {
        var controllerArray = [UIViewController]()
        let month = TodyViewController()
        month.title = "Month"
        controllerArray.append(month)
        
        let today = TodyViewController()
        today.title = "Today"
        controllerArray.append(today)
        
        let week = TodyViewController()
        week.title = "Week"
        controllerArray.append(week)
        
        pageMenu1 = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu1!.view)
        
        pageMenu1!.delegate = self
    }
    
    func willMoveToPage(controller: UIViewController, index: Int){
        let TrendingController = controller as! TodyViewController
        TrendingController.currType = index
    }
    func didMoveToPage(controller: UIViewController, index: Int){
        
    }

}
