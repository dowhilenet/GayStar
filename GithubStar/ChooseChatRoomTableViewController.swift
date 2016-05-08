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

        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //用户登陆
        WilddogManager.wilddogLogin()
        //检测是否有用户信息
        let user = UserRealm.selectUser()
        
        guard let _ = user else { GithubOAuth.GithubOAuth(self); return }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let stars = StarRealm.selectStars()
        stars.forEach { (star) in
            let room = WilddogChatRoomModel(star: star)
            rooms.append(room)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let room = rooms[indexPath.row]
        cell.textLabel?.text = room.roomName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chatController = LGChatController()
        chatController.hidesBottomBarWhenPushed = true
        chatController.title = rooms[indexPath.row].roomName
        chatController.delegate = self
        navigationController?.pushViewController(chatController, animated: true)
    }

}

extension ChooseChatRoomTableViewController: LGChatControllerDelegate {
    
    func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool {
        
        return false
    }
    func chatController(chatController: LGChatController, didAddNewMessage message: LGChatMessage) {
        
    }
}

