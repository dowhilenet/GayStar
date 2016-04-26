//
//  StarsTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/21.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON


class StarsTableViewController: UITableViewController {
   
    let cellId = "StarsCell"
  
    var stars = [StarDataModel]()
 
    //下拉刷新控件
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    //选择控件
    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Stared", rightTitle: "Ungrouped")
    var page = 1
    var downpages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let home = NSHomeDirectory()
            print(home)
      
        runkeepeSwitch()
        tableviewConfig()
        pulldownConfig()
        
        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
        stars = StarSQLiteModel.selectStars()
        //检查是否需要更新。
        updatestar()
        UserModel.requestDataAndInseret()

    }

    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  

    /**
     配置 switch
     */
    private func runkeepeSwitch(){
    runkeeperSwitch.backgroundColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
    runkeeperSwitch.selectedBackgroundColor = .whiteColor()
    runkeeperSwitch.tintColor = .whiteColor()
    runkeeperSwitch.selectedTitleColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
    runkeeperSwitch.titleFont = UIFont(name: "OpenSans", size: 13.0)
    runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
    runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
    runkeeperSwitch.addTarget(self, action: #selector(StarsTableViewController.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
    self.navigationItem.titleView = runkeeperSwitch
    }

    /**
     根据选择显示数据
     
     - parameter sender: sender
     */
    func switchValueDidChange(sender:DGRunkeeperSwitch){
        if self.runkeeperSwitch.selectedIndex == 0{
            stars = StarSQLiteModel.selectStars()
            self.tableView.reloadData()
        }else{
            stars = StarSQLiteModel.selectStarsByGroups()
            self.tableView.reloadData()
        }
    }
    /**
     Table View 配置
     */
    private func tableviewConfig(){
        
        self.tableView.estimatedRowHeight = 88.00
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor(red:
            240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0,
            alpha: 0.8)
        self.tableView.registerClass(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
   
    
    /**
     配置下拉组建
     */
    private func pulldownConfig(){
        //下拉刷新样式设计
        loadingView.tintColor = PullToRefreshTintColor
        self.tableView.dg_setPullToRefreshFillColor(PullToRefreshFillColor)
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
        //下拉刷新执行的函数
        self.tableView.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
    }
    
    /**
     下拉刷新数据
     */
//    MARK: Pull down data
    func pulldowndata(){
        //查看是否有 token
        
        guard let _ = Defaults[.token] else{
        
            ProgressHUD.showError("Not Logged in", interaction: true)
            GithubOAuth.GithubOAuth(self)
            self.tableView.dg_stopLoading()
            return
        }
        
        let remoteCount = Defaults[.updateCount]
        let localcount = Defaults[.starredCount]
        if localcount > remoteCount {
            self.tableView.dg_stopLoading()
            return
        }
        
        downpages = (remoteCount - localcount) / 100 + 1
        Defaults[.starredCount] = remoteCount
        Defaults.synchronize()
        requestPagedata()
    }
    
    func requestPagedata() {
        
        //下载完成后刷新界面
        func downalltip() {
            ProgressHUD.showSuccess("Having Down All Data")
            if self.runkeeperSwitch.selectedIndex == 0{
                stars = StarSQLiteModel.selectStars()
            }else{
                stars = StarSQLiteModel.selectStarsByGroups()
            }
            
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
        }
        //如果 所有数据已经下载完成则退出下载
        guard page <= downpages else { downalltip() ; return }
        
        
        StarRequestHelper.stared.requestStared("\(page)"){ (stars) in
            guard let _ = stars else {
                ProgressHUD.showError("No Data", interaction: true)
                self.tableView.dg_stopLoading()
                self.tableView.reloadData()
                return
            }
            self.page += 1
            self.requestPagedata()
        }
        
    }

}




typealias UItableviewDataSource = StarsTableViewController

extension UItableviewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return stars.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! StarsTableViewCell
        let star = stars[indexPath.row]
        cell.initCell(star)
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        let groupAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Group") { (UITableaction, indexpath) -> Void in
            let vc = TagViewController()
            vc.item = self.stars[indexPath.row]
            //隐藏tabar
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        groupAction.backgroundColor = UIColor.blackColor()
        return [groupAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消点击状态
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let star = stars[indexPath.row]
        //初始化项目详细信息界面
        let starView = StarInformationViewController()
        starView.hidesBottomBarWhenPushed = true
        starView.item = star
        self.navigationController?.pushViewController(starView, animated: true)
    }
}




