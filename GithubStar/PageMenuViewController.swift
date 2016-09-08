//
//  PageMenuViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/4.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit



class PageMenuViewController: UIViewController , CAPSPageMenuDelegate , ChooseLangueTableViewControllerDelegate{
    
    var pageMenu : CAPSPageMenu?
    var showcasesPageMenu: CAPSPageMenu?
    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Repository", rightTitle: "Developer")
    var lang: String?
    
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
        .ViewBackgroundColor(UIColor.whiteColor()),
        //Menu 背景颜色
        .ScrollMenuBackgroundColor(UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)),
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        pageMenuConfig()
        runkeepeSwitch()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "choocelang")
//        self.navigationItem.rightBarButtonItem = rightButton
    }
    
//    func choocelang(){
//        let vc = ChooseLangueTableViewController()
//        vc.rootviewcontroller = self
//        navigationController?.pushViewController(vc, animated: true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     配置 switch
     */
    fileprivate func runkeepeSwitch(){
        runkeeperSwitch.backgroundColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
        runkeeperSwitch.selectedBackgroundColor = .white()
        runkeeperSwitch.tintColor = .white()
        runkeeperSwitch.selectedTitleColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
        runkeeperSwitch.titleFont = UIFont(name: "OpenSans", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        runkeeperSwitch.autoresizingMask = [.flexibleWidth]
        runkeeperSwitch.addTarget(self, action: #selector(PageMenuViewController.switchValueDidChange(_:)), for: .valueChanged)
        self.navigationItem.titleView = runkeeperSwitch
    }
    
    /**
     根据选择显示数据
     
     - parameter sender: sender
     */
    func switchValueDidChange(_ sender:DGRunkeeperSwitch){
        if self.runkeeperSwitch.selectedIndex == 0{
            pageMenuConfig()
        }else{
            showcasesPageMenuConfig()
        }
    }
    
    
    
    func pageMenuConfig(){
        var controllerArray = [UIViewController]()
        let today = TrendingRepositoriesViewController()
        today.title = "Today"
        today.contantView = self
        controllerArray.append(today)
        
        let week = TrendingRepositoriesViewController()
        week.title = "Week"
        week.contantView = self
        controllerArray.append(week)
        
        let month = TrendingRepositoriesViewController()
        month.title = "Month"
        month.contantView = self
        controllerArray.append(month)
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 64.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.delegate = self
    }
    
    func showcasesPageMenuConfig() {
        var controllerArray = [UIViewController]()
        
        let today = TrendingDevelopersTableViewController()
        today.contantView = self
        today.title = "Today"
        controllerArray.append(today)
        
        let week = TrendingDevelopersTableViewController()
        week.title = "Week"
        week.contantView = self
        controllerArray.append(week)
        
        let month = TrendingDevelopersTableViewController()
        month.title = "Month"
        month.contantView = self
        controllerArray.append(month)
        
        showcasesPageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 64.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(showcasesPageMenu!.view)
        showcasesPageMenu!.delegate = self
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int){
       
        if controller is TrendingRepositoriesViewController {
            let TrendingController = controller as! TrendingRepositoriesViewController
            TrendingController.currType = index
        }else if controller is TrendingDevelopersTableViewController {
            let showcaseController = controller as! TrendingDevelopersTableViewController
            showcaseController.currType = index
        }
    }

    func didSelectLan(_ lan:String) {
        lang = lan
    }
}
