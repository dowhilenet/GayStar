//
//  MonthExploreViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/26.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
//import Unbox
//import DGElasticPullToRefresh
//import ObjectMapper
class MonthExploreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var tableview:UITableView!
    
    var repositoriesModel = [GithubStarsRealm]()
    var lang = "all"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        tableview = UITableView()
        self.view.addSubview(tableview)
        tableview.registerClass(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: "MonthCell")
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 88.00
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(EdgeInsets(top: 64, left: 0, bottom: 64, right: 0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MonthCell", forIndexPath: indexPath) as! StarsTableViewCell
        
        cell.initCellByStarModel(repositoriesModel, index: indexPath)
        
        return cell
    }


}
