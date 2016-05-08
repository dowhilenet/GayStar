////
////  ChatTableViewController.swift
////  GithubStar
////
////  Created by xiaolei on 16/3/28.
////  Copyright © 2016年 xiaolei. All rights reserved.
////
//
//import UIKit
//import SnapKit
//import Wilddog
//import SwiftyJSON
//
//class ChatTableViewController: UIViewController {
//
//    
//    var room: WilddogChatRoomModel!
//
//    var dataArray: [ChatModel]!
//  
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        dataArray = [ChatModel]()
//        
//      
//        
////        inputBackView.sendMessage(imageBlock: { (image, textView) in
////            
////            self.dataArray.append(ChatModel.creatMessageFromMeByImage(image))
////            self.chatTableView.reloadData()
////            self.chatTableView.scrollToBottom(animation: true)
////            }, textBlock: { (text, textView) in
////                let model = ChatModel.creatMessageFromMeByText(text)
////                //服务器添加数据
////                self.configWilddog(model)
////            }) { (voice, textView) in
////                
////        }
//        
//
//        
//        fullmessages()
//    }
//
//    
//
//    
//
//    // wilddog 添加子节点
//    func configWilddog(chat: ChatModel) -> Void {
//        let roomid = room.roomId
//        let roomref = WilddogManager.ref.childByAppendingPath(roomid)
//        let messageKey = chat.time + chat.userId
//        let messageValue = [
//            "user":chat.userName,
//            "userid":chat.userId,
//            "headurl":chat.headImage,
//            "time":chat.time,
//            "message":chat.text
//        ]
//        roomref.updateChildValues([messageKey:messageValue])
//    }
//    /**
//     从服务器获取数据
//     */
//    func fullmessages() {
//        //选择当前登陆用户
//        let model = UserRealm.selectUser()!
//        //聊天室模型
//        var chatModel = ChatModel()
//        //根据房间号添加子节点
//        let roomid = room.roomId
//        print(roomid)
//        let roomref = WilddogManager.ref.childByAppendingPath(roomid)
//        //检测子节点的数据变化
//        roomref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
//            //获取新添加节点的内容
//            let messages = snapshot.value
//            //解析json
//            let messagesJson = JSON(messages)
//            //判断节点是否是本地登陆用户
//            if messagesJson["user"].stringValue == model.name {
//                chatModel.from = .Me
//            }else {
//                chatModel.from = .Other
//            }
//            //设置chatmodel 的属性
//            chatModel.headImage = messagesJson["headurl"].stringValue
//            chatModel.text = messagesJson["message"].stringValue
//            chatModel.time = messagesJson["time"].stringValue
//            chatModel.userName = messagesJson["user"].stringValue
//            //将新添加的数据放入到 data array 中刷新界面
//            self.dataArray.append(chatModel)
//            self.chatTableView.reloadData()
//            //表格的最底部
//            self.chatTableView.scrollToBottom(animation: true)
//            }) { (eror) in
//                
//                print(eror.localizedDescription)
//        }
//    }
//
//}
//
//
//
//
//// MARK: LGChatControllerDelegate
//
//extension ChatTableViewController: LGChatControllerDelegate {
//    
//}
//
//
//extension ChatTableViewController {
//    func launchChatController() {
//        let chatController = LGChatController()
//        //选择当前登陆用户
//        let model = UserRealm.selectUser()!
//        chatController.title = "Simple Chat"
//        chatController.delegate = self
//    }
//}
