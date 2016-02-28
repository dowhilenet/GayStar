//
//  StarsTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/21.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyUserDefaults
import Unbox


extension Int{
    func toString() -> String{
        return String(self)
    }
}

extension String{
    func toInt() -> Int?{
        return Int(self)
    }
}

//给下一个页面传递数据

protocol PushStarProtocol {
    func didSelectedStar(item:GithubStarsRealm)
}


class StarsTableViewController: UITableViewController{
    
    let cellId = "StarsCell"
    //realm 选择 结果
    var items:Results<(GithubStarsRealm)>!
    //代理
    var stardelegate: PushStarProtocol?
    //下拉刷新控件
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    var page = 1
    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Stared", rightTitle: "Ungrouped")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let home = NSHomeDirectory()
            print(home)
        
        runkeepeSwitch()
        tableviewConfig()
        pulldownConfig()
        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
        //获取Starred 总数
        GetStarredCount.starredCount { (count) -> Void in
            if let count = count {
                Defaults[.starredCount] = count
                Defaults.synchronize()
            }

        }
        //获取table 数据
        self.items = GithubStarsRealmAction.selectStars()
    }

    
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
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
    runkeeperSwitch.addTarget(self, action: Selector("switchValueDidChange:"), forControlEvents: .ValueChanged)
    self.navigationItem.titleView = runkeeperSwitch
    }

    /**
     根据选择显示数据
     
     - parameter sender: sender
     */
    func switchValueDidChange(sender:DGRunkeeperSwitch){
        if self.runkeeperSwitch.selectedIndex == 0{
            self.items = GithubStarsRealmAction.selectStars()
            self.tableView.reloadData()
        }else{
            self.items = GithubStarsRealmAction.selectStarsSortByUngrouped()
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
        GetStarredCount.starredCount { (page) -> Void in
            if let page = page {
                Defaults[.starredCount] = page
                Defaults.synchronize()
            }
        }
   
        downData()
    }
    
    

   
    /**
     下载数据
     */
//    MARK: downData
    
    private func downData(){
        if Defaults[.HaveDownAllPagesStars]{
        self.page = 1
        Defaults[.HaveDownAllPagesStars] = false
        Defaults.synchronize()
        }
        Alamofire.request(GithubAPI.star(page: "\(page++)"))
            .validate()
            .responseData { (response) -> Void in
                
                guard let data = response.data , stars:[GithubStarsRealm] = Unbox(data)
                    else{
                        ProgressHUD.showError("No Data", interaction: true)
                        self.tableView.dg_stopLoading()
                        return
                }
                
                
                guard stars.count > 0 else{
                    Defaults[.HaveDownAllPagesStars] = true
                    Defaults.synchronize()
                    ProgressHUD.showSuccess("Have Down All Data")
                    if self.runkeeperSwitch.selectedIndex == 0{
                    self.items = GithubStarsRealmAction.selectStars()
                    }else{
                    self.items = GithubStarsRealmAction.selectStarsSortByName()
                    }
                    
                    self.tableView.reloadData()
                    self.tableView.dg_stopLoading()
                    return
                }
                
                GithubStarsRealmAction.insertStars(stars, callblocak: { (bool) -> Void in
                    if bool {

                            ProgressHUD.showSuccess("Down \(self.page - 1) Page Data")
                            self.downData()
//                        }
                    }else{
                        ProgressHUD.showError("No Data", interaction: true)
                        self.tableView.dg_stopLoading()
                    }
                })
                
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        let groupAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Group") { (UITableaction, indexpath) -> Void in
            let vc = TagViewController()
            self.stardelegate = vc
            self.stardelegate?.didSelectedStar(self.items[indexPath.row])
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        groupAction.backgroundColor = UIColor.blackColor()
        return [groupAction]
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if items == nil || items.count == 0{
        self.tableView.configKongTable("There is no data. try the drop-down refresh")
        return 0
        }
        
        return 1
    }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
           return items.count
        
    }

     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            //取消点击状态
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            let star = items[indexPath.row]
            //初始化项目详细信息界面
            
            let starView = StarInformationViewController()
            starView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(starView, animated: true)
            self.stardelegate = starView
            self.stardelegate?.didSelectedStar(star)
        
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! StarsTableViewCell
            cell.initCellItems(items, index: indexPath)
        return cell
        
    }

}


extension UITableView{
    func configKongTable(title:String){
        let messageLbl = UILabel(frame:CGRectMake(0, 0,self.bounds.size.width,self.bounds.size.height))
        messageLbl.backgroundColor = UIColor.clearColor()
        messageLbl.text = title
        messageLbl.numberOfLines = 0
        messageLbl.textAlignment = .Center
        messageLbl.font = UIFont(name: "FrederickatheGreat", size: 18)
        messageLbl.sizeToFit()
        self.backgroundView = messageLbl
        self.separatorStyle = .None
    }
}





