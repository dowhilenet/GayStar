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
import Graph
import CoreData

class StarsTableViewController: UITableViewController {
   
    let cellId = "StarsCell"
    var fetchedResultsController: NSFetchedResultsController!
    let managedContext = CoreDadaStack.sharedInstance.context

 
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
        configFetchedResultsCon()
        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
    }

    override func viewDidAppear(animated: Bool) {
        guard let _ = Defaults[.token] else{ return }
        //检查是否需要更新。
        updatestar()
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //fetchedResultsController 初始化
    func configFetchedResultsCon() {
        let fetchRequest = NSFetchRequest(entityName: "GitubStars")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch let eror as NSError {
            print("Error: \(eror.localizedDescription)")
        }
        
        
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
//            self.items = GithubStarsRealmAction.selectStars()
            self.tableView.reloadData()
        }else{
//            self.items = GithubStarsRealmAction.selectStarsSortByUngrouped()
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
        //获取总共的页数
        GetStarredCount.starredCount { (page) -> Void in
            if let page = page {
                Defaults[.updateCount] = page
                Defaults.synchronize()
            }
        }
        //执行下载
        downData()
    }
    
    
   
    /**
     下载数据
     */
//    MARK: downData
    
    private func downData(){
        let updateCount = Defaults[.updateCount]
        let count = Defaults[.starredCount]
        // 判断服务器页书和本地页书，服务器大于本地则更新
        //小于的话，暂不更新
        if updateCount > count {
            downpages = (updateCount - count) / 100 + 1
            Defaults[.starredCount] = page
            Defaults.synchronize()
        }else {
            self.tableView.dg_stopLoading()
            return
        }
        //请求服务器数据
        requestPagedata()
    }
    
    func requestPagedata() {
        
        //下载完成后刷新界面
        func downalltip() {
            ProgressHUD.showSuccess("Having Down All Data")
            if self.runkeeperSwitch.selectedIndex == 0{
//                self.items = GithubStarsRealmAction.selectStars()
            }else{
//                self.items = GithubStarsRealmAction.selectStarsSortByName()
            }
            
            self.tableView.dg_stopLoading()
        }
        //如果 所有数据已经下载完成则退出下载
        guard page <= downpages else { downalltip() ; return }
        
        Alamofire.request(GithubAPI.star(page: "\(page)"))
            .validate()
            .responseData { (response) -> Void in
                //请求页书加一
                self.page += 1
                // 判断是否请求到了数据
                guard let data = response.data
                    else{
                        ProgressHUD.showError("No Data", interaction: true)
                        self.tableView.dg_stopLoading()
                        self.tableView.reloadData()
                        return
                }
                
                let starEntity = NSEntityDescription.entityForName("GitubStars", inManagedObjectContext: CoreDadaStack.sharedInstance.context)
                
                let jsonArray = JSON(data: data).arrayValue
                
                    jsonArray.forEach({ (json) in
                        
                        let star =  GitubStars(entity: starEntity!, insertIntoManagedObjectContext: CoreDadaStack.sharedInstance.context)
                        star.initData(json)
                        do {
                            try self.managedContext.save()
                        } catch let error as NSError {
                            print("Error: \(error.localizedDescription)")
                        }
                    })
                self.requestPagedata()
        }
        
    }

}

typealias NSFetchedResultsDelegate = StarsTableViewController

extension NSFetchedResultsDelegate:NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type == .Insert {
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}


typealias UItableviewDataSource = StarsTableViewController

extension UItableviewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! StarsTableViewCell
        let star = fetchedResultsController.objectAtIndexPath(indexPath) as! GitubStars
        cell.initCellItems(star)
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        let groupAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Group") { (UITableaction, indexpath) -> Void in
            let vc = TagViewController()
            //            vc.item = self.items[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        groupAction.backgroundColor = UIColor.blackColor()
        return [groupAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消点击状态
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //            let star = items[indexPath.row]
        //初始化项目详细信息界面
        
        let starView = StarInformationViewController()
        starView.hidesBottomBarWhenPushed = true
        //            starView.item = star
        self.navigationController?.pushViewController(starView, animated: true)
    }
}




