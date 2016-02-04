//
//  GroupItemsTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/2.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import RealmSwift

protocol GroupItemsTableViewControllerDelegate{
    func groupName(name:GithubGroupRealm)
}

class GroupItemsTableViewController: UITableViewController {
    
    
    //realm 选择 结果
    var items:Results<(GithubStarsRealm)>!
    var name: GithubGroupRealm!
    var groupdelegate: GroupItemsTableViewControllerDelegate?
    var starDelegate: PushStarProtocol?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: "groupItems")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 88
        self.tableView.separatorColor = UIColor(red:
            240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0,
            alpha: 0.8)
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addRepository")
        let deletebuttonItem = editButtonItem()
        self.navigationItem.rightBarButtonItems = [addButtonItem,deletebuttonItem]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addRepository")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.title = name.name
        items = GithubStarsRealmAction.selectStarByGroupNameSortedByName(name.name)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        items = GithubStarsRealmAction.selectStarByGroupNameSortedByName(name.name)
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if items.count == 0 {
            self.tableView.configKongTable("There is no data  try add a repository")
            return 0
        }
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupItems", forIndexPath: indexPath) as! StarsTableViewCell
        cell.initCellItems(items, index: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let star = items[indexPath.row]
        let vc = StarInformationViewController()
        vc.hidesBottomBarWhenPushed = true
        starDelegate = vc
        starDelegate?.didSelectedStar(star)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            GithubStarsRealmAction.updateStarOwnGroup(items[indexPath.row], groupName: "", back: { (ok) -> Void in
                if ok {
                    ProgressHUD.showSuccess("Success")
                    }else{
                    ProgressHUD.showError("Error")
                    }
                })
            items = GithubStarsRealmAction.selectStarByGroupNameSortedByName(name.name)
            self.tableView.reloadData()
        }
    }
    
    
}


extension GroupItemsTableViewController{
    func addRepository(){
        let showListView = ShowRepositoryListTableViewController()
        self.groupdelegate = showListView
        groupdelegate?.groupName(name)
        presentViewController(showListView, animated: true, completion: nil)
    }
}


extension GroupItemsTableViewController:ReferenceTableViewControllerDelegate{
    func didSelectedGroupDelegate(group: GithubGroupRealm) {
        name = group
    }
}



