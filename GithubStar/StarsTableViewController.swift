//
//  StarsTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/21.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit




class StarsTableViewController: UITableViewController {
   
    let cellId = "StarsCell"
  
    var stars = [StarRealm]()
 
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
        stars = StarRealm.selectStars()
        //检查是否需要更新。
        updatestar()
        UserRealm.requestDataAndInseret()

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
    fileprivate func runkeepeSwitch(){
    runkeeperSwitch.backgroundColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
    runkeeperSwitch.selectedBackgroundColor = .white()
    runkeeperSwitch.tintColor = .white()
    runkeeperSwitch.selectedTitleColor = UIColor(red: 0.44, green: 0.836, blue: 0.953, alpha: 1)
    runkeeperSwitch.titleFont = UIFont(name: "OpenSans", size: 13.0)
    runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
    runkeeperSwitch.autoresizingMask = [.flexibleWidth]
    runkeeperSwitch.addTarget(self, action: #selector(StarsTableViewController.switchValueDidChange(_:)), for: .valueChanged)
    self.navigationItem.titleView = runkeeperSwitch
    }

    /**
     根据选择显示数据
     
     - parameter sender: sender
     */
    func switchValueDidChange(_ sender:DGRunkeeperSwitch){
        if self.runkeeperSwitch.selectedIndex == 0{
            stars = StarRealm.selectStars()
            self.tableView.reloadData()
        }else{
            stars = StarRealm.selectStarsByGroups()
            self.tableView.reloadData()
        }
    }
    /**
     Table View 配置
     */
    fileprivate func tableviewConfig(){
        
        self.tableView.estimatedRowHeight = 88.00
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor(red:
            240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0,
            alpha: 0.8)
        self.tableView.register(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
   
    
    /**
     配置下拉组建
     */
    fileprivate func pulldownConfig(){
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
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "Not Logged in", autoClear: true, autoClearTime: 2)
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
            SwiftNotice.showNoticeWithText(NoticeType.success, text: "Having Down All Data", autoClear: true, autoClearTime: 2)
            if self.runkeeperSwitch.selectedIndex == 0{
                stars = StarRealm.selectStars()
            }else{
                stars = StarRealm.selectStarsByGroups()
            }
            
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
        }
        //如果 所有数据已经下载完成则退出下载
        guard page <= downpages else { downalltip() ; return }
        
        
        StarRequestHelper.stared.requestStared("\(page)"){ (stars) in
            if stars.count > 0 {
                self.page += 1
                self.requestPagedata()
            }else {
                SwiftNotice.showNoticeWithText(NoticeType.success, text: "No Data", autoClear: true, autoClearTime: 2)
                self.tableView.dg_stopLoading()
                self.tableView.reloadData()
            }
        }
        
    }

}




typealias UItableviewDataSource = StarsTableViewController

extension UItableviewDataSource {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return stars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StarsTableViewCell
        let star = stars[(indexPath as NSIndexPath).row]
        cell.initCell(star)
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let groupAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Group") { (UITableaction, indexpath) -> Void in
            let layout = TagViewFloutLaout()
            layout.flowLaoutInit()
            let vc = TagCollectionViewController(collectionViewLayout: layout)
            vc.item = self.stars[(indexPath as NSIndexPath).row]
            //隐藏tabar
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        groupAction.backgroundColor = UIColor.black
        return [groupAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消点击状态
        tableView.deselectRow(at: indexPath, animated: true)
        
        let star = stars[(indexPath as NSIndexPath).row]
        //初始化项目详细信息界面
        let starView = StarInformationViewController()
        starView.hidesBottomBarWhenPushed = true
        starView.item = star
        self.navigationController?.pushViewController(starView, animated: true)
    }
}




