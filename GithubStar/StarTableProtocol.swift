//
//  StarTableProtocol.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/22.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation

protocol StarTabelProtocol {
    func tableviewConfig(tableView:UITableView, cellType: UITableViewCell, cellID: String) -> Void
}

extension StarTabelProtocol {
    func tableViewConfig(tableView:UITableView, cellType: UITableViewCell, cellID: String) -> Void {
        tableView.estimatedRowHeight = 88.00
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor(red:
            240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0,
                         alpha: 0.8)
        tableView.registerClass(cellType.classForCoder(), forCellReuseIdentifier: cellID)
    }
}