//
//  SearchStarsTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 16/1/7.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

class SearchStarsTableViewController: UITableViewController {
    
    var searchResults = [GithubStarsRealm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(StarsTableViewCell().classForCoder, forCellReuseIdentifier: "searchcell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchcell", forIndexPath: indexPath) as! StarsTableViewCell
        cell.initCellByStarModel(searchResults, index: indexPath)
        return cell
    }

}
