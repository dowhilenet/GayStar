//
//  StarBase.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//



/// 有关项目的一些个公有的属性
class StarBase: Object {
    
    dynamic var idjson: Int64 = 0
    dynamic var stargazersCountjson: Int64 = 0
    dynamic var namejson: String = ""
    dynamic var autherURLjson: String = ""
    dynamic var fullNamejson: String = ""
    dynamic var decriptionjson: String = ""
    dynamic var languagejson: String = ""
    dynamic var avatarURLjson: String = ""
    dynamic var htmlURLjson: String = ""
    dynamic var homePagejson: String = ""
    dynamic var htmljson: String = ""
    dynamic var autherNamejson: String = ""
    
    /**
     通过JSON来初始化一个 StarBase
     
     - parameter jsonData: JSON 数据
     
     - returns: StarBase
     */
    convenience init(jsonData: JSON){
        self.init()
        idjson = jsonData["id"].int64Value
        stargazersCountjson = jsonData["stargazers_count"].int64Value
        namejson = jsonData["name"].stringValue
        autherURLjson = jsonData["owner","url"].stringValue
        fullNamejson = jsonData["full_name"].stringValue
        decriptionjson = jsonData["description"].stringValue
        languagejson = jsonData["language"].stringValue
        avatarURLjson = jsonData["owner","avatar_url"].stringValue
        htmlURLjson = jsonData["owner","html_url"].stringValue
        homePagejson = jsonData["homepage"].stringValue
        htmljson = jsonData["html_url"].stringValue
        autherNamejson = jsonData["owner","login"].stringValue
    }
}
