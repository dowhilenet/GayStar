//
//  StarsTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/21.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyUserDefaults
import Unbox

extension Int{
    func toString() -> String{
        return String(self)
    }
}

extension String{
    func toInt() -> Int?{
        return Int(self)
    }
}

//给下一个页面传递数据
protocol PushStarProtocol:class{
    func didSelectedStar(item:GithubStarsRealm)
}


class StarsTableViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate{
    
    let cellId = "StarsCell"
    //realm 选择 结果
    var items:Results<(GithubStarsRealm)>!
    //代理
    var stardelegate: PushStarProtocol?
    //下拉刷新控件
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    //Search Controller
    var searchController: UISearchController!
    var searchResults = [GithubStarsRealm]()
    
    var page = 1
    var shouldShowSearchResults = false
    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Time", rightTitle: "Name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let home = NSHomeDirectory()
            print(home)
//        configureSearchController()
        runkeepeSwitch()
        tableviewConfig()
        pulldownConfig()
        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
        //获取Starred 总数
        GetStarredCount.starredCount { (count) -> Void in
            if let count = count {
                Defaults[.starredCount] = count
                Defaults.synchronize()
            }

        }
  
        //获取table 数据
       self.items = GithubStarsRealmAction.selectStars()
   
    }

    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    /**
     配置 switch
     */
    private func runkeepeSwitch(){
    
    runkeeperSwitch.backgroundColor = UIColor(red: 239.0/255.0, green: 95.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    runkeeperSwitch.selectedBackgroundColor = .whiteColor()
    runkeeperSwitch.tintColor = .whiteColor()
    runkeeperSwitch.selectedTitleColor = UIColor(red: 239.0/255.0, green: 95.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
    runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
    runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
    runkeeperSwitch.addTarget(self, action: Selector("switchValueDidChange:"), forControlEvents: .ValueChanged)
    self.navigationItem.titleView = runkeeperSwitch
    }

    /**
     根据选择显示数据
     
     - parameter sender: sender
     */
    func switchValueDidChange(sender:DGRunkeeperSwitch!){
        if self.runkeeperSwitch.selectedIndex == 0{
            self.items = GithubStarsRealmAction.selectStars()
            self.tableView.reloadData()
        }else{
            self.items = GithubStarsRealmAction.selectStarsSortByName()
            self.tableView.reloadData()
        }
    }
    /**
     Table View 配置
     */
    private func tableviewConfig(){
        self.tableView.estimatedRowHeight = 88.00
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerClass(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: cellId)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    /**
     配置搜索
     */
    //MARK: SearchController
    private func configureSearchController(){
        
        searchController = ({
            let con = UISearchController(searchResultsController:nil)
            con.searchResultsUpdater = self
            con.dimsBackgroundDuringPresentation = true
            con.searchBar.placeholder = "Search here..."
            con.searchBar.delegate = self
            con.searchBar.sizeToFit()
            self.tableView.tableHeaderView = con.searchBar
            self.definesPresentationContext = true
            return con
        })()
    }
    //MARK: UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController){
        let searchString = searchController.searchBar.text
        filterContentForSearchText(searchString!)
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText:String){
            searchResults =  items.filter({ (star) -> Bool in
            return star.name.lowercaseString.containsString(searchText.lowercaseString)
            })
    }
    //MARK:UISearchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults{
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    
    /**
     配置下拉组建
     */
    private func pulldownConfig(){
        //下拉刷新样式设计
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red: 239.0/255.0, green: 95.0/255.0, blue: 49.0/255.0, alpha: 1.0))
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
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
        GetStarredCount.starredCount { (page) -> Void in
            if let page = page {
                Defaults[.starredCount] = page
                Defaults.synchronize()
            }
        }
   
        downData()
    }
    
    
    
   
    /**
     下载数据
     */
//    MARK: downData
    
    private func downData(){
        if Defaults[.HaveDownAllPagesStars]{
        self.page = 1
        Defaults[.HaveDownAllPagesStars] = false
        Defaults[.number] = 0
        Defaults.synchronize()
        }
        Alamofire.request(GithubAPI.star(page: "\(page++)"))
            .validate()
            .responseData { (response) -> Void in
                
                guard let data = response.data , stars:[GithubStarsRealm] = Unbox(data)
                    else{
                        ProgressHUD.showError("No Data", interaction: true)
                        self.tableView.dg_stopLoading()
                        return
                }
                
                
                guard stars.count > 0 else{
                    Defaults[.HaveDownAllPagesStars] = true
                    Defaults.synchronize()
                    ProgressHUD.showSuccess("Have Down All Data")
                    if self.runkeeperSwitch.selectedIndex == 0{
                    self.items = GithubStarsRealmAction.selectStars()
                    }else{
                    self.items = GithubStarsRealmAction.selectStarsSortByName()
                    }
                    
                    self.tableView.reloadData()
                    self.tableView.dg_stopLoading()
                    return
                }
                
                stars.forEach({ (star) -> () in
                    star.number = ++Defaults[.number]
                    Defaults.synchronize()
                })
                GithubStarsRealmAction.insertStars(stars, callblocak: { (bool) -> Void in
                    if bool {

                            ProgressHUD.showSuccess("Down \(self.page - 1) Page Data")
                            self.downData()
//                        }
                    }else{
                        ProgressHUD.showError("No Data", interaction: true)
                        self.tableView.dg_stopLoading()
                    }
                })
                
        }
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if items == nil{
        let messageLbl = UILabel(frame:CGRectMake(0, 0,self.tableView.bounds.size.width,self.tableView.bounds.size.height))
        messageLbl.text = "There is no data, try the drop-down refresh"
        messageLbl.numberOfLines = 0
        messageLbl.textAlignment = .Center
        messageLbl.sizeToFit()
        tableView.backgroundView = messageLbl
        tableView.separatorStyle = .None
        return 0
        }
        
        return 1
    }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if shouldShowSearchResults{
            return searchResults.count
        }
           return items.count
        
    }

     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消点击状态
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if shouldShowSearchResults{
            let star = searchResults[indexPath.row]
            let starView = StarInformationViewController()
            self.navigationController?.pushViewController(starView, animated: true)
            self.stardelegate = starView
            self.stardelegate?.didSelectedStar(star)
        }else{
            let star = items[indexPath.row]
            //初始化项目详细信息界面
            let starView = StarInformationViewController()
            self.navigationController?.pushViewController(starView, animated: true)
            self.stardelegate = starView
            self.stardelegate?.didSelectedStar(star)
        }
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! StarsTableViewCell
            cell.initCellItems(items, index: indexPath)
        return cell
        
    }

}



