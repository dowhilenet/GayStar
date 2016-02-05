
//  TodyViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/26.
//  Copyright © 2015年 xiaolei. All rights reserved.


import UIKit
import SnapKit
import Alamofire
import Unbox
import RealmSwift

class TrendingRepositoriesViewController: UITableViewController{
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    var repositoriesModel: Results<(GithubStarTrending)>!
   
    var lang: String?
    var currType = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoriesModel = GithubStarsRealmAction.selectTrengind(currType)
        tableViewConfig()
    }

    
    func tableViewConfig(){
        
        tableView.registerClass(StarsTableViewCell.self, forCellReuseIdentifier: "TodayCell")
        tableView.estimatedRowHeight = 88.00
        tableView.rowHeight = UITableViewAutomaticDimension
    
        loadingView.tintColor = PullToRefreshTintColor
        tableView.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PullToRefreshFillColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    

  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

            cell.initCellItemsToTrending(repositoriesModel, index: indexPath)
        
        return cell
    }

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
            ProgressHUD.showError("Trending repositories results are currently being dissected.")
            self.tableView.dg_stopLoading()
            return
        }
        GithubStarsRealmAction.deleteTrending(currType)
        names.forEach { (name) -> () in
            Alamofire.request(GithubAPI.repos(repos: name))
                .responseData({ (res) -> Void in
                    guard let data = res.data  else{
                        self.tableView.dg_stopLoading()
                        ProgressHUD.showError("Error0")
                        return
                    }
                    self.switchInsertType(data)
                    self.tableView.dg_stopLoading()
                    self.repositoriesModel = GithubStarsRealmAction.selectTrengind(self.currType)
                    self.tableView.reloadData()
                })
        }
    }
    
    func switchInsertType(data:NSData) {
        
            guard let stars: GithubStarTrending = Unbox(data) else {
                self.tableView.dg_stopLoading()
                ProgressHUD.showError("Error1")
                return
            }
        GithubStarsRealmAction.insertStarTrending(currType,starsModel: stars, callblocak: { (success) -> Void in
                guard success else {
                    self.tableView.dg_stopLoading()
                    ProgressHUD.showError("Error2")
                    return
                }
            })
    }

}