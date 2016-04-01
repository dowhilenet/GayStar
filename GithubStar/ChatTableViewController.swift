//
//  ChatTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/28.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Wilddog
import SwiftyJSON

class ChatTableViewController: UIViewController {

    private let leftCellId = "ChatLeftMessageCell"
    private let rightCellId = "ChatRightMessageCell"
    
    var room: WilddogChatRoomModel!
    var chatTableView: UITableView!
    var inputBackView: InputView!
    var dataArray: [ChatModel]!
    var inputViewConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = [ChatModel]()
        
        inputBackView = InputView()
        view.addSubview(inputBackView)
        
        inputViewConstraint = NSLayoutConstraint(
            item: inputBackView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0
        )
        
        inputBackView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
        }
        
        view.addConstraint(inputViewConstraint!)
        
        inputBackView.sendMessage(imageBlock: { (image, textView) in
            
            self.dataArray.append(ChatModel.creatMessageFromMeByImage(image))
            self.chatTableView.reloadData()
            self.chatTableView.scrollToBottom(animation: true)
            }, textBlock: { (text, textView) in
                let model = ChatModel.creatMessageFromMeByText(text)
                //服务器添加数据
                self.configWilddog(model)
            }) { (voice, textView) in
                
        }
        
        chatTableView = UITableView(frame: CGRectZero, style: .Plain)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.separatorStyle = .None
        chatTableView.keyboardDismissMode = .Interactive
        chatTableView.estimatedRowHeight = 60
        
        view.addSubview(chatTableView)
        chatTableView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(self.view).offset(64)
            make.bottom.equalTo(inputBackView.snp_top)
        }
        
        chatTableView.registerClass(ChatLeftMessageCell.classForCoder(), forCellReuseIdentifier: leftCellId)
        chatTableView.registerClass(ChatRightMessageCell.classForCoder(), forCellReuseIdentifier: rightCellId)
        chatTableView.estimatedRowHeight = 100
        
        fullmessages()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatTableViewController.keyboardFrameChanged(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        chatTableView.scrollToBottom(animation: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardFrameChanged(notification: NSNotification) {
        
        let dict = NSDictionary(dictionary: notification.userInfo!)
        let keyboardValue = dict.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let bottomDistance = mainScreenSize().height - keyboardValue.CGRectValue().origin.y
        let duration = Double(dict.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        
        UIView.animateWithDuration(duration, animations: {
            self.inputViewConstraint!.constant = -bottomDistance
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                self.chatTableView.scrollToBottom(animation: true)
        })
    }
    
    private func mainScreenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    // wilddog 添加子节点
    func configWilddog(chat: ChatModel) -> Void {
        let roomid = room.roomId
        let roomref = WilddogManager.ref.childByAppendingPath(roomid)
        let messageKey = chat.time + chat.userId
        let messageValue = [
            "user":chat.userName,
            "userid":chat.userId,
            "headurl":chat.headImage,
            "time":chat.time,
            "message":chat.text
        ]
        roomref.updateChildValues([messageKey:messageValue])
    }
    /**
     从服务器获取数据
     */
    func fullmessages() {
        //选择当前登陆用户
        let model = UserSQLiteModel.selectData()
        //聊天室模型
        var chatModel = ChatModel()
        //根据房间号添加子节点
        let roomid = room.roomId
        let roomref = WilddogManager.ref.childByAppendingPath(roomid)
        //检测子节点的数据变化
        roomref.queryLimitedToLast(99).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            //获取新添加节点的内容
            let messages = snapshot.value
            //解析json
            let messagesJson = JSON(messages)
            //判断节点是否是本地登陆用户
            if messagesJson["user"].stringValue == model.name {
                chatModel.from = .Me
            }else {
                chatModel.from = .Other
            }
            //设置chatmodel 的属性
            chatModel.headImage = messagesJson["headurl"].stringValue
            chatModel.text = messagesJson["message"].stringValue
            chatModel.time = messagesJson["time"].stringValue
            chatModel.userName = messagesJson["user"].stringValue
            //将新添加的数据放入到 data array 中刷新界面
            self.dataArray.append(chatModel)
            self.chatTableView.reloadData()
            //表格的最底部
            self.chatTableView.scrollToBottom(animation: true)
            }) { (eror) in
                
                print(eror.localizedDescription)
        }
    }

}

// MARK: - Table view data source

extension ChatTableViewController: UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.row]
        if model.from == .Me {
            let cell = tableView.dequeueReusableCellWithIdentifier(rightCellId,forIndexPath: indexPath) as! ChatRightMessageCell
            cell.configUIWithModel(model)
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(leftCellId, forIndexPath: indexPath) as! ChatLeftMessageCell
            cell.configUIWithModel(model)
            return cell
        }
        
    }
}


extension ChatTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
}
