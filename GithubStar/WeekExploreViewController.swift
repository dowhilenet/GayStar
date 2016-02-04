//
//  WeekExploreViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/26.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import Unbox
//import DGElasticPullToRefresh

class WeekExploreViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var tableview:UITableView!
    var repositoriesModel = [GithubStarsRealm]()
    var lang = "all"
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        tableview = UITableView()
        self.view.addSubview(tableview)
        tableview.registerClass(StarsTableViewCell.self, forCellReuseIdentifier: "WeekCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 88.00
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.trailing.leading.equalTo(self.view)
            make.bottom.equalTo(self.view.snp_bottom).offset(-64)
        }
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableview.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
        tableview.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.5))
        tableview.dg_setPullToRefreshBackgroundColor(tableview.backgroundColor!)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pulldowndata(){
        
    }
    
    deinit {
        tableview.dg_removePullToRefresh()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeekCell", forIndexPath: indexPath) as! StarsTableViewCell
        
        cell.initCellByStarModel(repositoriesModel, index: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesModel.count
    }

}
