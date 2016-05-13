//
//  TrendingDevelopersTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/5.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit


class TrendingDevelopersTableViewController: UITableViewController{

    var currType = 0
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var contantView: PageMenuViewController!
    var devs = [TrendingDelevloperRealm]()
    override func viewDidLoad() {
        super.viewDidLoad()
        devs = TrendingDelevloperRealm.selectByType(Int64(currType))
        tableViewConfig()
    }

    func tableViewConfig(){
        
        tableView.estimatedRowHeight = 88.00
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor(red:
            240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0,
            alpha: 0.8)
        tableView.registerClass(TrendingDevTableViewCell.self, forCellReuseIdentifier: "DevCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 106, right: 0)
        loadingView.tintColor = PullToRefreshTintColor
        tableView.dg_addPullToRefreshWithActionHandler(pulldowndata, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PullToRefreshFillColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func pulldowndata() {
        
        func falseOrTrue(res:Bool) {
            guard res else {
                self.tableView.dg_stopLoading()
//                ProgressHUD.showError("Trending developers results are currently being dissected.")
                return
            }
            devs = TrendingDelevloperRealm.selectByType(Int64(currType))
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
        }
        
        
        switch currType {
        case 0:
            TrendingDevelopers.ToDay.getRepo(0, name: nil, back: { (res) -> Void in
                falseOrTrue(res)
            })
        case 1:
            TrendingDevelopers.Week.getRepo(1, name: nil, back: { (res) -> Void in
                falseOrTrue(res)
            })
        default:
            TrendingDevelopers.Monhly.getRepo(2, name: nil, back: { (res) -> Void in
               falseOrTrue(res)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if devs.count == 0 {
            self.tableView.configKongTable("There is no data. try the drop-down refresh")
            return 0
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DevCell", forIndexPath: indexPath) as! TrendingDevTableViewCell
        cell.initCell(devs, index: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = TrendingDevelopinfoViewController()
        vc.dev = devs[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        contantView.navigationController?.pushViewController(vc, animated: true)
    }

}
