//
//  UserRealm.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import RealmSwift
import SwiftyJSON
import Alamofire

class UserRealm: Object {
    
    dynamic var login = ""
    dynamic var id = ""
    dynamic var avatarURL = ""
    dynamic var htmlurl = ""
    dynamic var followersURL = ""
    dynamic var followingURL = ""
    dynamic var gistsURL = ""
    dynamic var starredURL = ""
    dynamic var subscriptionsURL = ""
    dynamic var organiationsURL = ""
    dynamic var reposURL = ""
    dynamic var eventsURL = ""
    dynamic var name = ""
    dynamic var blog = ""
    dynamic var location = ""
    dynamic var email = ""
    dynamic var publicRepos = ""
    dynamic var publicGists = ""
    dynamic var followers = ""
    dynamic var following = ""
    dynamic var createdAt = ""
    dynamic var updatedAt = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private static func insert(data:UserRealm) -> Bool {
        let res = false
        do {
            try RealmData.share.realm.write({ 
                RealmData.share.realm.add(data, update: true)
            })
            return !res
        }catch {
            return res
        }
    }
    
    static func selectUser() -> UserRealm? {
        return RealmData.share.realm.objects(UserRealm).first
    }
    
    private convenience init(data: NSData) {
        self.init()
        let json = JSON(data: data)
        login = json["login"].stringValue
        id = json["id"].stringValue
        avatarURL = json["avatar_url"].stringValue
        htmlurl = json["html_url"].stringValue
        followersURL = json["followers_url"].stringValue
        followingURL = json["following_url"].stringValue
        gistsURL = json["gists_url"].stringValue
        starredURL = json["starred_url"].stringValue
        organiationsURL = json["organizations_url"].stringValue
        subscriptionsURL = json["subscriptions_url"].stringValue
        reposURL = json["repos_url"].stringValue
        eventsURL = json["events_url"].stringValue
        name = json["name"].stringValue
        blog = json["blog"].stringValue
        location = json["location"].stringValue
        email = json["email"].stringValue
        publicRepos = json["public_repos"].stringValue
        publicGists = json["public_gists"].stringValue
        followers = json["followers"].stringValue
        following = json["following"].stringValue
        createdAt = json["created_at"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
    /**
     请求用户数据
     
     - parameter back: 返回用户的数据
     */
    private static func requestData(back: (data: NSData?) -> Void)  {
        Alamofire.request(GithubAPI.me).responseJSON { (res) in
            guard let res = res.data else {
                back(data: nil)
                return
            }
            back(data: res)
        }
    }
    
    /**
     请求数据并插入到数据库
     
     - returns: true or false
     */
    static func requestDataAndInseret() {
        requestData { (data) in
            guard let data = data else { print("no data") ;return }
            let user = UserRealm(data: data)
            insert(user)
        }
        
    }
    
    
}