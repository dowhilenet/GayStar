//
//  ChatViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/19.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import JSQMessagesViewController





class ChatViewController: JSQMessagesViewController {
    
    //消息数组
    var messages = [JSQMessage]()
    //登录用户
    var user: UserRealm!
    //选择的房间
    var room:WilddogChatRoomModel!
    
    //收到消息的背景颜色
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    //发出消息的背景颜色
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectUser = UserRealm.selectUser()
        guard let user = selectUser else { return }
        self.user = user
        setUpSenderUser()
        setUpMessageView()
        setUpWilddog()

    }
    
}
//MARK: Function
extension ChatViewController {
    
    func setUpMessageView() {
    }
    
     // wilddog 添加消息
    func addMessageToWilddog(_ chat:JSQMessage) {
        //在选择的房间号下进行添加消息
        let roomid = room.roomId
        let roomref = WilddogManager.ref?.child(byAppendingPath: roomid)
        let messageKey = String(chat.date) + chat.senderId
        let messageValue = [
                "user":chat.senderDisplayName,
                "userid":chat.senderId,
//                "headurl":chat.headImage,
                "time":String(chat.date),
                "message":chat.text
        ]
        roomref?.updateChildValues([messageKey:messageValue])
        }
    
    func setUpSenderUser() {
        //用户的id
        senderId = user.id
        //用户的名称
        senderDisplayName = user.name
        // view controller should automatically scroll to the most recent message
        automaticallyScrollsToMostRecentMessage = true
    }
    
    func setUpWilddog() {
        //根据房间号添加子节点
        let roomid          = room.roomId
        let roomref         = WilddogManager.ref?.child(byAppendingPath: roomid)
        //检测子节点的数据变化
        roomref?.queryLimited(toLast: 99).observe(.childAdded, with: { (snapshot) in
            //获取新添加节点的内容
            let messages        = snapshot?.value
            //解析json
            let messagesJson    = JSON(messages)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            let time = dateFormatter.dateFromString(messagesJson["time"].stringValue)!
            let message = JSQMessage(senderId: messagesJson["userid"].stringValue, senderDisplayName: messagesJson["user"].stringValue, date: time, text: messagesJson["message"].stringValue)
            //将新添加的数据放入到 data array 中刷新界面
            self.messages.append(message)
            self.collectionView.reloadData()
            
        }) { (eror) in
            
            print(eror?.localizedDescription)
        }
    }
    
}

//MARK: override JSQMessagesCollectionViewDataSource
extension ChatViewController {
    //每个 item 显示的消息内容
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    //头像
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    //如果消息是自己的话 显示的背景颜色为 outgoingBubble
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId == user.id ? outgoingBubble : incomingBubble
    }
    
    
    //删除某一条聊天记录的操作
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        
    }
    //显示网名
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        switch message.senderId {
        case user.id:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    //显示时间
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        return NSAttributedString(string: String(message.date))
    }
    //消息主体下边要显示的东西
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return NSAttributedString(string: "")
    }
    

}
//MARK:  UICollectionViewDataSource
extension ChatViewController {
    
    //显示的消息的条数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
}
//MARK: override ChatViewController Function
extension ChatViewController {
    
    //按下附件按钮的操作
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
    // 按下发送按钮的操作
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        //初始化一条消息
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        //将消息添加到 messages 数组中
        addMessageToWilddog(message!)
//        messages.append(message)
        finishSendingMessage(animated: true)
//        collectionView.reloadData()
    }
}

//MARK: JSQMessagesCollectionViewDelegateFlowLayout

extension ChatViewController {
    
    
    //消息上边要显示的网名的高度
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    //消息上边要显示的时间的高度
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    //消息下边要显示的高度
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    //点击头像后的回调
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {
        print("点击头像后的回调")
    }
    
    //点击 message 的回调
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        print("点击 message 的回调")
    }
    
    //点击 cell 的回调
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        print("点击 cell 的回调")
    }
    
    //点击 TapLoadEarlierMessagesButton
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        print("TapLoadEarlierMessagesButton")
    }
}
