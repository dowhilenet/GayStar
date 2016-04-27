//
//  StarRealm.swift
//  GithubStar
//
//  Created by xiaolei on 16/4/27.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import RealmSwift
import SwiftyJSON

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
    
    override static func primaryKey() -> String? {
        return "idjson"
    }
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

class StarRealm: StarBase {
    dynamic var groupsName: String? = nil
    /**
     向数据库中插入新的数据
     
     - parameter star: 要插入的数据
     */
    class func intsertStar(star: StarRealm) {
        
    }
    /**
     获取所有的项目
     
     - returns: 项目
     */
    class func selectStars() -> [StarRealm] {
        var res: [StarRealm] = [StarRealm]()
        return res
    }
    /**
     选出所有没有被分组的项目
     
     - returns: 没有被分组的项目
     */
    class func selectStarsByGroups() -> [StarRealm] {
        var res: [StarRealm] = [StarRealm]()
        return res
    }
    /**
     某一分组下的项目数目
     
     - parameter name: 分组的名称
     
     - returns: 分组下的项目数目
     */
    class func selecCount(name: String) -> Int {
        var cont = 0
        return cont
    }
    /**
     获取某个分组下的所有数目
     
     - parameter name: 分组名称
     
     - returns: 分组下的所有项目
     */
    class func selectStarByGroupName(name:String) -> [StarRealm] {
        var res: [StarRealm] = [StarRealm]()
        return res
    }
    
    /**
     删除某一分组下的所有项目
     
     - parameter id: 分组的ID
     */
    class func deleteStarFromGroup(id: Int64) {
        
    }

}
