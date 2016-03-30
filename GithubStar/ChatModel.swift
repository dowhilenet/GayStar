//
//  ChatModel.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/28.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation

enum ChatFrom:Int {
    case Me
    case Other
}

enum ChatMessageType {
    case Text
    case Image
    case Voice
    case Video
    case Map
}



struct ChatModel {
    //用户信息
    var from: ChatFrom = .Me
    var messageType: ChatMessageType = .Text
    
    var headImage: String!
    var userId = ""
    var userName = ""
    var time = ""
    
    //消息类型
    var text: String = ""
    var image: UIImage?
    var voice: NSData?
    //语音时长
    var voiceSecond: String?
    
    
    private static func configMe() -> ChatModel {
        var model = ChatModel()
        //初始化一些公共信息
        let user = UserSQLiteModel.selectData()
        model.userId = user.id
        model.userName = user.name
        model.headImage = user.avatarURL
        return model
    }
    static func creatMessageFromMeByText(text:String) -> ChatModel {
        var model = configMe()
        model.messageType = .Text
        model.text = text
        model.time = NSDate().description
        return model
    }
    
    static func creatMessageFromMeByImage(image:UIImage) -> ChatModel{
        var model = configMe()
        model.messageType = .Image
        model.image = image
        model.time = random()%2==1 ? NSDate().description : ""
        return model
    }
    
    
    static func creatMessageFromMeByVoice(voice:NSData) -> ChatModel{
        var model = configMe()
        model.messageType = .Voice
        model.voice = voice
        model.time = random()%2==1 ? NSDate().description : ""
        model.voiceSecond = "5"
        return model
    }
    
}