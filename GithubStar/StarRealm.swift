//
//  StarRealm.swift
//  GithubStar
//
//  Created by xiaolei on 16/4/27.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import RealmSwift
import SwiftyJSON
import Alamofire
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

/// Stared 项目
class StarRealm: StarBase {
    
    override static func primaryKey() -> String? {
        return "idjson"
    }
    
    //Star 的分组
    dynamic var groupsName: String = ""
    
    
    class func initStarArray(data: NSData) -> [StarRealm] {
        let json = JSON(data: data)
        var stars = [StarRealm]()
        for (_ , subJson) in json {
            let star = StarRealm(jsonData: subJson)
            stars.append(star)
        }
        return stars
    }
    
    /**
     向数据库中插入新的数据
     
     - parameter star: 要插入的数据
     */
    class func intsertStar(star: StarRealm) -> Bool {
        let res = false
        do{
           try RealmData.share.realm.write({
            RealmData.share.realm.add(star, update: true)
           })
            return !res
        }catch {
            return res
        }
    }
    /**
     向数据库中插入新的数据
     
     - parameter star: 要插入的数据
     */
    class func insertStars(stars: [StarRealm]) -> Bool {
        let res = false
        do {
            try RealmData.share.realm.write({ 
                RealmData.share.realm.add(stars, update: true)
            })
            return !res
        }catch {
            return res
        }
    }
    /**
     获取所有的项目
     
     - returns: 项目
     */
    class func selectStars() -> [StarRealm] {
        return Array<StarRealm>(RealmData.share.realm.objects(StarRealm).sorted("namejson", ascending: true))
    }
    /**
     选出所有没有被分组的项目
     
     - returns: 没有被分组的项目
     */
    class func selectStarsByGroups() -> [StarRealm] {
        let predicate = NSPredicate(format: "groupsName = %@", "")
        return Array<StarRealm>(RealmData.share.realm.objects(StarRealm).filter(predicate).sorted("namejson", ascending: true))
    }
    /**
     某一分组下的项目数目
     
     - parameter name: 分组的名称
     
     - returns: 分组下的项目数目
     */
    class func selecCount(name: String) -> Int {
        let predicate = NSPredicate(format: "groupsName  = %@", name)
        return RealmData.share.realm.objects(StarRealm).filter(predicate).count
    }
    /**
     获取某个分组下的所有数目
     
     - parameter name: 分组名称
     
     - returns: 分组下的所有项目
     */
    class func selectStarByGroupName(name:String) -> [StarRealm] {
        let predicate = NSPredicate(format: "groupsName  = %@", name)
        return Array<StarRealm>(RealmData.share.realm.objects(StarRealm).filter(predicate).sorted("namejson", ascending: true))
    }
    
    class func selectStarByID(ID: Int64) -> StarRealm? {
     
        return RealmData.share.realm.objects(StarRealm).filter("idjson = \(ID)").first
    }
    
    /**
     删除某一分组下的所有项目
     
     - parameter id: 分组的ID
     */
    class func deleteStarFromGroup(groupName: String) -> Bool {
        let res = false
        let stars = RealmData.share.realm.objects(StarRealm).filter(NSPredicate(format: "groupsName = %@", groupName))
        stars.forEach { (star) in
            star.groupsName = ""
        }
        do {
            try RealmData.share.realm.write({ 
                RealmData.share.realm.add(stars)
            })
            return !res
        } catch {
            return res
        }
        
    }

}

/// Trending Star 项目
class TrendingStarRealm: StarBase {
    
    dynamic var type: Int64 = 0
    /**
     插入数据
     
     - parameter star: Trending Star
     
     - returns: true or false
     */
    class func intsertStar(star:TrendingStarRealm) -> Bool {
        let res: Bool = false
        return res
    }
    /**
     根据类型筛选不同的热门库
     
     - parameter type: 类型参数
     
     - returns: 热门仓库
     */
    class func selectStarsBytype(type:Int64) -> [TrendingStarRealm] {
        var res: [TrendingStarRealm] = [TrendingStarRealm]()
        return res
    }
    /**
     根据热门项目的分类
     
     - parameter type: 类型
     
     - returns: true or  false
     */
    class func deleteAllStars(type: Int64) -> Bool {
        let res: Bool = false
        return res
    }
    
}

class StarReadMeRealm: Object {
    dynamic var id: Int64 = 0
    dynamic var readmeValue: String? = nil
    dynamic var readmeURL: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /**
     插入数据（更新）
     
     - parameter data: readme model
     
     - returns: true or false
     */
    class func insertReadMe(data:StarReadMeRealm) -> Bool {
        let res = false
        do {
            try RealmData.share.realm.write({
                RealmData.share.realm.add(data, update: true)
            })
            return !res
        } catch {
            return res
        }
    }
    
    /**
     根据项目的id 来筛选
     
     - parameter id: Star ID
     
     - returns: Star read me
     */
    class func selectRreadMeByID(id:Int64) -> StarReadMeRealm? {
        return RealmData.share.realm.objects(StarReadMeRealm).filter(NSPredicate(format: "id == %@", NSNumber(longLong: id))).first
    }
}

class StarGroupRealm: Object {
    dynamic var name = ""
    dynamic var count:Int64 = 0
    
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    /**
     插入数据
     
     - parameter group: 分组model
     
     - returns: true or false
     */
    class func insert(group:StarGroupRealm) -> Bool {
        let res = false
        do {
            try RealmData.share.realm.write({ 
                RealmData.share.realm.add(group, update: true)
            })
            return !res
        }catch {
            return res
        }
    }
    
    /**
     选择所有的分组
     
     - returns: 分组数组
     */
    class func select() -> [StarGroupRealm] {
        return Array<StarGroupRealm>(RealmData.share.realm.objects(StarGroupRealm))
    }
    /**
     删除某个分组
     
     - parameter name: 分组的名称
     
     - returns: 删除的结果  true or false
     */
    class func deleteGroup(name:String) -> Bool {
        let res = false
        let group = StarGroupRealm(name: name)
        do {
            try RealmData.share.realm.write({
                RealmData.share.realm.delete(group)
            })
            
            guard StarRealm.deleteStarFromGroup(name)  else {
                return res
            }
            return !res

        }catch {
            return res
        }
    }
}

class TrendingDelevloperRealm: Object {
    
    dynamic var githubname = ""
    dynamic var imageURL = ""
    dynamic var fullName = ""
    dynamic var githubURL = ""
    dynamic var repoRUL = ""
    dynamic var repoName = ""
    dynamic var repoDec = ""
    dynamic var typename: Int64 = 0
    
    /**
     插入热门开发者的数据
     
     - parameter developer: 热门开发者的模型
     
     - returns: 插入的结果 true or false
     */
    class func insert(developer: TrendingDelevloperRealm) -> Bool {
        let res = false
        return res
    }
    /**
     根据开发的ID来筛选开发的信息
     
     - parameter type: 开发者id
     
     - returns: 开发者模型
     */
    class func selectByType(type: Int64) -> TrendingDelevloperRealm {
        let developer = TrendingDelevloperRealm()
        return developer
    }
    /**
     根据类型的ID 来删除某一类型下的所有热门开发者
     
     - parameter type: 类型ID
     
     - returns: 操作的结果 true or  false
     */
    class func deleteByType(type: Int64) -> Bool {
        let res = false
        return res
    }
    
}

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
    
    private static func requestData(back: (data: NSData?) -> Void)  {
        Alamofire.request(GithubAPI.me).responseJSON { (res) in
            guard let res = res.data else {
                back(data: nil)
                return
            }
            back(data: res)
        }
    }
    
    static func requestDataAndInseret() -> Bool {
        var res = false
        requestData { (data) in
            guard let data = data else { print("no data") ;return }
           
        }
        return res
    }
}