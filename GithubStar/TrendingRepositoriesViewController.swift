
//  TodyViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/26.
//  Copyright © 2015年 xiaolei. All rights reserved.


import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class TrendingRepositoriesViewController: UITableViewController{
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var repositoriesModel = [TrendingStarRealm]()
 
    var lang: String?
    var currType = 0
    
    var contantView: PageMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoriesModel = TrendingStarRealm.selectStarsBytype(Int64(currType))
        tableViewConfig()
    }

    
    func tableViewConfig(){
        
        tableView.registerClass(StarsTableViewCell.self, forCellReuseIdentifier: "TodayCell")
        tableView.estimatedRowHeight = 88.00
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 106, right: 0)
        loadingView.tintColor = PullToRefreshTintColor
        tableView.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PullToRefreshFillColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if repositoriesModel.count == 0 {
            self.tableView.configKongTable("There is no data. try the drop-down refresh")
            return 0
        }
        return 1
    }
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

           return repositoriesModel.count
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TodayCell", forIndexPath: indexPath) as! StarsTableViewCell
        let star = repositoriesModel[indexPath.row]
        cell.initCell(star)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = TrendingRepositionInfoViewController()
        vc.hidesBottomBarWhenPushed = true
        let model = repositoriesModel[indexPath.row]
        vc.repositionModel = model
        contantView.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     下拉刷新
     */
    func pulldowndata(){
        
        switch currType {
        case 0:
            TrendingRepositories.ToDay.getRepo(lang, back: { (name) -> Void in
                self.requestRepoData(name)
            })
            
        case 1:
            TrendingRepositories.Week.getRepo(lang, back: { (name) -> Void in
                self.requestRepoData(name)
            })
        default:
            TrendingRepositories.Monhly.getRepo(lang, back: { (name) -> Void in
                self.requestRepoData(name)
            })
        }
    }
    
    func requestRepoData(names:[String]){
        guard names.count > 0 else {
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "Trending repositories results are currently being dissected.", autoClear: true, autoClearTime: 2)
            self.tableView.dg_stopLoading()
            return
        }
        /**
         *  删除之前缓存的项目
         */
        TrendingStarRealm.deleteAllStars(Int64(currType))

        names.forEach { (name) -> () in
            Alamofire.request(GithubAPI.repos(repos: name))
                .responseData({ (res) -> Void in
                    guard let data = res.data  else{
                        self.tableView.dg_stopLoading()
                        SwiftNotice.showNoticeWithText(NoticeType.error, text: "Trending repositories results are currently being dissected.", autoClear: true, autoClearTime: 2)
                        return
                    }
                    self.switchInsertType(data)
                })
        }
    }
    
    func switchInsertType(data:NSData) {
        
        let star = TrendingStarRealm(jsonData: JSON(data: data))
        star.type = Int64(currType)
        TrendingStarRealm.intsertStar(star)
        repositoriesModel = TrendingStarRealm.selectStarsBytype(Int64(currType))
        tableView.reloadData()
        tableView.dg_stopLoading()
    }
    
  

}
