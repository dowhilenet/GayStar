
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

class TodyViewController: UITableViewController{
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    var repositoriesModel: Results<(GithubStarTrending)>!
    var repositoriesModel1: Results<(GithubStarWeekTrending)>!
    var repositoriesModel2: Results<(GithubStarMonthyTrending)>!
    var lang: String?
    var currType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        switchRepositoriesModel()
        tableViewConfig()
    }
    
    func switchRepositoriesModel() {
        switch currType {
        case 0:
            repositoriesModel = GithubStarsRealmAction.selectTrengind()
        case 1:
            repositoriesModel1 = GithubStarsRealmAction.selectWeekTrengind()
        default:
            repositoriesModel2 = GithubStarsRealmAction.selectMonthyTrengind()
        }
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currType {
        case 0:
           return repositoriesModel.count
        case 1:
           return repositoriesModel1.count
        default:
           return repositoriesModel2.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TodayCell", forIndexPath: indexPath) as! StarsTableViewCell
        switch currType {
        case 0:
            cell.initCellItemsToTrending(repositoriesModel, index: indexPath)
        case 1:
            cell.initCellItemsToWeekTrending(repositoriesModel1, index: indexPath)
        default:
            cell.initCellItemsToMontyTrending(repositoriesModel2, index: indexPath)
        }
        return cell
    }

    func pulldowndata(){
        
        var names = [String]()
        switch currType {
        case 0:
            names = TrendingRepositories.ToDay.getRepo(lang)
            
        case 1:
            names = TrendingRepositories.Week.getRepo(lang)
        default:
            names = TrendingRepositories.Monhly.getRepo(lang)
        }
        
        guard names.count > 0 else {
            ProgressHUD.showError("Error404")
            self.tableView.dg_stopLoading()
            return
        }
        
        
        
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
                    self.switchRepositoriesModel()
                    self.tableView.reloadData()
                })
        }
        
        
    }
    
    func switchInsertType(data:NSData) {
        switch self.currType {
        case 0:
            guard let stars: GithubStarTrending = Unbox(data) else {
                self.tableView.dg_stopLoading()
                ProgressHUD.showError("Error1")
                return
            }
            
            GithubStarsRealmAction.insertStarTrending([stars], callblocak: { (success) -> Void in
                guard success else {
                    self.tableView.dg_stopLoading()
                    ProgressHUD.showError("Error2")
                    return
                }
            })
            
        case 1:
            
            guard let stars: GithubStarWeekTrending = Unbox(data) else {
                self.tableView.dg_stopLoading()
                ProgressHUD.showError("Error1")
                return
            }
            
            GithubStarsRealmAction.insertStarWeekTrending([stars], callblocak: { (success) -> Void in
                guard success else {
                    self.tableView.dg_stopLoading()
                    ProgressHUD.showError("Error2")
                    return
                }
            })
        default:
            guard let stars: GithubStarMonthyTrending = Unbox(data) else {
                self.tableView.dg_stopLoading()
                ProgressHUD.showError("Error1")
                return
            }
            GithubStarsRealmAction.insertStarMontyTrending([stars], callblocak: { (success) -> Void in
                guard success else {
                    self.tableView.dg_stopLoading()
                    ProgressHUD.showError("Error2")
                    return
                }
            })
        }// end switch
    }

}
