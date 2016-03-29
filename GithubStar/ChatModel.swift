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
    var from: ChatFrom = .Me
    var messageType: ChatMessageType = .Text
    var userName = ""
    var time = ""
    var headImage: String!
    var text: String?
    var image: UIImage?
    var voice: NSData?
    var voiceSecond: String?
    

    static func creatMessageFromMeByText(text:String) -> ChatModel {
        var model = ChatModel()
        model.messageType = .Text
        model.text = text
        model.headImage = "http://baidu.com"
        model.configMeBaseInfo()
        return model
    }
    
    static func creatMessageFromMeByImage(image:UIImage) -> ChatModel{
        var model = ChatModel()
        model.messageType = .Image
        model.image = image
        model.configMeBaseInfo()
        return model
    }
    
    
    static func creatMessageFromMeByVoice(voice:NSData) -> ChatModel{
        var model = ChatModel()
        model.messageType = .Voice
        model.voice = voice
        model.voiceSecond = "5"
        model.configMeBaseInfo()
        return model
    }
    
    private mutating func configMeBaseInfo() {
        from = .Me
        userName = "Daniel"
        time = random()%2==1 ? NSDate.init(timeIntervalSince1970: NSTimeInterval(random()%1000)).description : ""
    }
    
}