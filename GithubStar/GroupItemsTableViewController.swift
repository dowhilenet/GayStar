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
        
        self.tableView.register(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: "groupItems")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 88
        self.tableView.separatorColor = UIColor(red:
            240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0,
            alpha: 0.8)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addRepository))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = name
        stars = StarRealm.selectStarByGroupName(name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stars = StarRealm.selectStarByGroupName(name)
        self.tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if stars.count == 0 {
            self.tableView.configKongTable("There is no data  try add a repository")
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stars.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupItems", for: indexPath) as! StarsTableViewCell
        cell.initCell(stars[(indexPath as NSIndexPath).row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let star = stars[(indexPath as NSIndexPath).row]
        let vc = StarInformationViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.item = star
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let deleteStar = StarRealm.selectStarByID(stars[(indexPath as NSIndexPath).row].idjson)
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






