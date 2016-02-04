//
//  TodyViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/26.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

//import UIKit
//import SnapKit
//import Alamofire
//import Unbox
//import Haneke
//import DGElasticPullToRefresh
//class TodyViewController: UITableViewController{
//    
//    
//    var repositoriesModel = [GithubStarsRealm]()
//    var lang = "all"
//    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.registerClass(StarsTableViewCell.self, forCellReuseIdentifier: "TodayCell")
//        tableView.estimatedRowHeight = 88.00
//        tableView.rowHeight = UITableViewAutomaticDimension
//        
//        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
//        tableView.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
//        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.5))
//        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
//        
//    }
//    
//    func pulldowndata(){
//        let names = TrendingRepositories.ToDay.getRepo(lang)
//        names.forEach { (name) -> () in
//            Alamofire.request(GithubAPI.repos(repos: name))
//            .validate()
//            .responseData({ (res) -> Void in
//                guard let data = res.data else{
//                    self.tableView.dg_stopLoading()
//                    return
//                }
//                let cache = Shared.dataCache
//                cache.set(value: data, key: "today\(self.lang)")
//                cache.fetch(key: "today\(self.lang)")
//                    .onSuccess { (data) -> () in
//                        self.repositoriesModel = Unbox(data)!
//                        self.tableView.reloadData()
//                        self.tableView.dg_stopLoading()
//                }
//            })
//        }
//        
//    }
//    
//    deinit {
//        tableView.dg_removePullToRefresh()
//    }
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        let cache = Shared.dataCache
//        cache.fetch(key: "today\(self.lang)")
//        .onSuccess { (data) -> () in
//            self.repositoriesModel = Unbox(data)!
//            self.tableView.reloadData()
//        }
//        .onFailure { (_) -> () in
//            self.noticeError("刷新试试", autoClear: true, autoClearTime: 1)
//        }
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return repositoriesModel.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("TodayCell", forIndexPath: indexPath) as! StarsTableViewCell
//        
//        cell.initCellByStarModel(repositoriesModel, index: indexPath)
//        return cell
//    }
//
//
//}
