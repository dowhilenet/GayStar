
//  TodyViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/26.
//  Copyright © 2015年 xiaolei. All rights reserved.


import UIKit
import SnapKit

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
        
        tableView.register(StarsTableViewCell.self, forCellReuseIdentifier: "TodayCell")
        tableView.estimatedRowHeight = 88.00
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 106, right: 0)
        loadingView.tintColor = PullToRefreshTintColor
        tableView.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PullToRefreshFillColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if repositoriesModel.count == 0 {
            self.tableView.configKongTable("There is no data. try the drop-down refresh")
            return 0
        }
        return 1
    }
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

           return repositoriesModel.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath) as! StarsTableViewCell
        let star = repositoriesModel[(indexPath as NSIndexPath).row]
        cell.initCell(star)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TrendingRepositionInfoViewController()
        vc.hidesBottomBarWhenPushed = true
        let model = repositoriesModel[(indexPath as NSIndexPath).row]
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
    
    func requestRepoData(_ names:[String]){
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
            Alamofire.request(GithubAPI.repos(repos: name)).responseData(completionHandler: { (res) in
                guard let data = res.data else {
                    self.tableView.dg_stopLoading()
                    SwiftNotice.showNoticeWithText(NoticeType.error, text: "Trending repositories results are currently being dissected.", autoClear: true, autoClearTime: 2)
                    return
                }
                self.switchInsertType(data)
            })
        }
    }
    
    func switchInsertType(_ data:Data) {
        
        let star = TrendingStarRealm(jsonData: JSON(data: data))
        star.type = Int64(currType)
        TrendingStarRealm.intsertStar(star)
        repositoriesModel = TrendingStarRealm.selectStarsBytype(Int64(currType))
        tableView.reloadData()
        tableView.dg_stopLoading()
    }
    
  

}
