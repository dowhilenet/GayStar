//
//  WilddogManager.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/29.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Wilddog

struct WilddogManager {
    
    static let ref = Wilddog(url: "https://gaystar.wilddogio.com")

    static func wilddogLogin() {
        //监听用户的登陆状况
        ref?.observeAuthEvent { (authData) in
            if authData != nil {
                //用户已经认证
                
            }else {
                //用户没有认证，进行匿名登陆
                WilddogManager.ref?.authAnonymously(completionBlock: { (error, autherData) in
                    if error == nil {
                        //登陆成功
                        print(autherData?.uid)
                    }else {
                        //登陆失败
                    }
                })
                
            }
        }
    }
}


struct WilddogChatRoomModel {
    var roomName = ""
    var roomId = ""
    var autherName = ""
    init(star: StarRealm) {
        roomId = String(star.idjson)
        roomName = star.namejson
        autherName = star.autherNamejson
    }
}




