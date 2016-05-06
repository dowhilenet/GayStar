//
//  GroupItemsTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/2.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

class GroupItemsTableViewController: UITableViewController {
    
    
    var stars = [StarRealm]()
    var name: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: "groupItems")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 88
        self.tableView.separatorColor = UIColor(red:
            240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0,
            alpha: 0.8)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.addRepository))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.title = name
        stars = StarRealm.selectStarByGroupName(name)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stars = StarRealm.selectStarByGroupName(name)
        self.tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if stars.count == 0 {
            self.tableView.configKongTable("There is no data  try add a repository")
            return 0
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stars.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupItems", forIndexPath: indexPath) as! StarsTableViewCell
        cell.initCell(stars[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let star = stars[indexPath.row]
        let vc = StarInformationViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.item = star
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let deleteStar = StarRealm.selectStarByID(stars[indexPath.row].idjson)
            StarRealm.updateGroup(deleteStar!, groupName: "")
            stars = StarRealm.selectStarByGroupName(name)
            self.tableView.reloadData()
        }
    }
    
    
}


extension GroupItemsTableViewController{
    func addRepository(){
        let showListView = ShowRepositoryListTableViewController()
        showListView.groupName = name
        navigationController?.pushViewController(showListView, animated: true)
    }
}






