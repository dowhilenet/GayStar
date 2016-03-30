//
//  ChooseChatRoomTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/28.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import Wilddog

class ChooseChatRoomTableViewController: UITableViewController {
    
    
    var rooms = [WilddogChatRoomModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(GroupTableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //用户登陆
        WilddogManager.wilddogLogin()
        
        for i in 0 ... 10 {
            let room = WilddogChatRoomModel(roomName: "room\(i)", roomId:  "\(i)")
            rooms.append(room)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! GroupTableViewCell
        let room = rooms[indexPath.row]
        cell.setButtonTitle(room.roomName)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chatVC = ChatTableViewController()
        chatVC.hidesBottomBarWhenPushed = true
        chatVC.room = rooms[indexPath.row]
        navigationController?.pushViewController(chatVC, animated: true)
    }

}

