//
//  GithubStarsRealm.swift
//  GITStare
//
//  Created by xiaolei on 15/12/17.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import RealmSwift
import Unbox
class GithubStarsRealm:Object,Unboxable{
    /// 项目ID
    dynamic var id                    = 0
    /// Open Iss
    dynamic var openIssuesCount       = 0
    /// Fork Count
    dynamic var forksCount            = 0
    /// Stars Count
    dynamic var stargazersCount       = 0
    /// Name
    dynamic var name                  = ""
    /// Auther URL
    dynamic var autherURL             = ""
    /// Full Name
    dynamic var fullName              = ""
    /// Description
    dynamic var decription:String?    = nil
    /// Language
    dynamic var language:String?      = nil
    /// Avatar URL
    dynamic var avatarURL             = ""
    /// HTML URL
    dynamic var htmlURL               = ""
    /// Pushed Time
    dynamic var pushedTime            = ""
    /// Home Page
    dynamic var homePage:String?      = nil

    dynamic var default_branch:String = ""
    
    dynamic var number:Int            = 0
    /**
     设置主键
     
     - returns: 主键
     */
    override static func primaryKey() -> String?{
        return "id"
    }
    /**
     设置索引
     
     - returns: 索引数组
     */
    override static func indexedProperties() -> [String]{
        return ["id","name","number"]
    }
    
    required convenience init(unboxer: Unboxer){
        self.init()
        fullName        = unboxer.unbox("full_name")
        decription      = unboxer.unbox("description")
        language        = unboxer.unbox("language")
        forksCount      = unboxer.unbox("forks_count")
        stargazersCount = unboxer.unbox("stargazers_count")
        avatarURL       = unboxer.unbox("owner.avatar_url")
        htmlURL         = unboxer.unbox("html_url")
        openIssuesCount = unboxer.unbox("open_issues_count")
        pushedTime      = unboxer.unbox("updated_at")
        homePage        = unboxer.unbox("homepage")
        name            = unboxer.unbox("name")
        autherURL       = unboxer.unbox("owner.url")
        id              = unboxer.unbox("id")
        default_branch  = unboxer.unbox("default_branch")
        
    }
}