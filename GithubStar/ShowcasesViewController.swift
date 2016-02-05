//
//  ShowcasesViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/5.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit

import Fuzi
import Alamofire
class ShowcasesViewController: UIViewController {

    
    var tableview: UITableView!
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var currType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewConfig()
        requestShowcasesData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableViewConfig() {
        tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 88.00
        tableview.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableview)
        tableview.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-110)
        }
        tableview.registerClass(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: "showcasescell")
        
        loadingView.tintColor = PullToRefreshTintColor
        tableview.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
        tableview.dg_setPullToRefreshFillColor(PullToRefreshFillColor)
        tableview.dg_setPullToRefreshBackgroundColor(tableview.backgroundColor!)
    }
    
    func pulldowndata(){
        requestShowcasesData()
    }
    
}

extension ShowcasesViewController: UITableViewDelegate {
    
}

extension ShowcasesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showcasescell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}