////
////  GithubStarsRealm.swift
////  GITStare
////
////  Created by xiaolei on 15/12/17.
////  Copyright © 2015年 xiaolei. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//import SwiftyJSON
//
//
//
//class StarRealm: Object {
//    /// 项目ID
//    dynamic var id                    = 0
//    /// Open Iss
//    dynamic var openIssuesCount       = 0
//    /// Fork Count
//    dynamic var forksCount            = 0
//    /// Stars Count
//    dynamic var stargazersCount       = 0
//    /// Name
//    dynamic var name                  = ""
//    /// Auther URL
//    dynamic var autherURL             = ""
//    /// Full Name
//    dynamic var fullName              = ""
//    /// Description
//    dynamic var decription:String?    = nil
//    /// Language
//    dynamic var language:String?      = nil
//    /// Avatar URL
//    dynamic var avatarURL             = ""
//    /// HTML URL
//    dynamic var htmlURL               = ""
//    /// Pushed Time
//    dynamic var pushedTime            = ""
//    /// Home Page
//    dynamic var homePage:String?      = nil
//    
//    dynamic var html                  = ""
//    
//    dynamic var default_branch:String = ""
//    
//    dynamic var autherName            = ""
//}
//
////MARK: GithubStarsRealm
//class GithubStarsRealm: StarRealm{
//
//    //other
//    dynamic var groupsNmae:String?    = nil
//    
//    /**
//     设置主键
//     
//     - returns: 主键
//     */
//    override static func primaryKey() -> String?{
//        return "id"
//    }
//    /**
//     设置索引
//     
//     - returns: 索引数组
//     */
//    override static func indexedProperties() -> [String]{
//        return ["id","name"]
//    }
//    
//   
//    class func dataToArray(data:NSData) -> [GithubStarsRealm] {
//        var restuts = Array<GithubStarsRealm>()
//        let jsondata = JSON(data: data).array
//        guard let jsondataArray = jsondata else { return restuts}
//        for json in jsondataArray {
//            let oneObject = GithubStarsRealm(data: json)
//            restuts.append(oneObject)
//        }
//        return restuts
//    }
//    
//    required convenience init(data:JSON) {
//        self.init()
//        let jsonData = data
//        id = jsonData["id"].intValue
//        openIssuesCount = jsonData["open_issues_count"].intValue
//        forksCount = jsonData["forks_count"].intValue
//        stargazersCount = jsonData["stargazers_count"].intValue
//        name = jsonData["name"].stringValue
//        autherURL = jsonData["owner","url"].stringValue
//        fullName = jsonData["full_name"].stringValue
//        decription = jsonData["description"].string
//        language = jsonData["language"].string
//        avatarURL = jsonData["owner","avatar_url"].stringValue
//        htmlURL = jsonData["owner","html_url"].stringValue
//        pushedTime = jsonData["updated_at"].stringValue
//        homePage = jsonData["homepage"].string
//        html = jsonData["html_url"].stringValue
//        default_branch = jsonData["default_branch"].stringValue
//        autherName = jsonData["owner","login"].stringValue
//    }
//}
//
//
//class GithubStarTrending: StarRealm{
////    
//    dynamic var typename              = ""
////    /**
////     设置主键
////     
////     - returns: 主键
////     */
//    override static func primaryKey() -> String?{
//        return "typename"
//    }
////    /**
////     设置索引
////     
////     - returns: 索引数组
////     */
//    override static func indexedProperties() -> [String]{
//        return ["id","name"]
//    }
//    
//    required convenience init(data:JSON) {
//        self.init()
//        let jsonData = data
//        id = jsonData["id"].intValue
//        openIssuesCount = jsonData["open_issues_count"].intValue
//        forksCount = jsonData["forks_count"].intValue
//        stargazersCount = jsonData["stargazers_count"].intValue
//        name = jsonData["name"].stringValue
//        autherURL = jsonData["owner","url"].stringValue
//        fullName = jsonData["full_name"].stringValue
//        decription = jsonData["description"].string
//        language = jsonData["language"].string
//        avatarURL = jsonData["owner","avatar_url"].stringValue
//        htmlURL = jsonData["owner","html_url"].stringValue
//        pushedTime = jsonData["updated_at"].stringValue
//        homePage = jsonData["homepage"].string
//        html = jsonData["html_url"].stringValue
//        default_branch = jsonData["default_branch"].stringValue
//        autherName = jsonData["owner","login"].stringValue
//    }
//}
//
//
//
////MARK: GithubStarReadMe
//class GithubStarReadMe: Object {
//    dynamic var id         = 0
//    dynamic var htmlString = ""
//    dynamic var html_url:String?   = nil
//    override static func primaryKey() -> String?{
//        return "id"
//    }
//}
//
//
////MARK: GithubGroupRealm
//class GithubGroupRealm: Object {
//    
//    dynamic var name       = ""
//    dynamic var count      = 0
//    
//    override static func primaryKey() -> String?{
//        return "name"
//    }
//    
//    override static func indexedProperties() -> [String]{
//        return ["name"]
//    }
//}
//
//class TrendingDelevlopeRealm: Object {
//    dynamic var githubname = ""
//    dynamic var imageURL = ""
//    dynamic var fullName = ""
//    dynamic var githubURL = ""
//    dynamic var repoRUL = ""
//    dynamic var repoName = ""
//    dynamic var repoDec = ""
//    dynamic var typename = ""
//    override static func primaryKey() -> String?{
//        return "typename"
//    }
//}
//
//
//
//class ShowcasesRealm: Object {
//    dynamic var title = ""
//    dynamic var url = ""
//    dynamic var imageurl = ""
//    
//    override static func primaryKey() -> String?{
//        return "title"
//    }
//}
//
//class ShowcasesRealmAction {
//    class func insert(data: [ShowcasesRealm]) {
//        try! realm.write({ () -> Void in
//            realm.add(data)
//        })
//    }
//    
//    class func select() -> Results<(ShowcasesRealm)> {
//        return realm.objects(ShowcasesRealm)
//    }
//}
//
//
//
//class TrendingDelevlopeRealmAction {
//    class func insert(type:Int,item:[TrendingDelevlopeRealm]) {
//        
//        delete(type)
//        
//        item.forEach { (item) -> () in
//            let ms = NSDate().timeIntervalSince1970
//            switch type {
//            case 0:
//                item.typename = "today" + String(ms)
//            case 1:
//                item.typename = "week" + String(ms)
//            default:
//                item.typename = "month" + String(ms)
//            }
//        }
//        
//        try! realm.write({ () -> Void in
//            realm.add(item, update: true)
//        })
//    }
//    
//    class func select(type: Int) -> Results<(TrendingDelevlopeRealm)> {
//        switch type {
//        case 0:
//            let predicate = NSPredicate(format: "typename CONTAINS %@", "today")
//            return realm.objects(TrendingDelevlopeRealm).filter(predicate)
//        case 1:
//            let predicate = NSPredicate(format: "typename CONTAINS %@", "week")
//            return realm.objects(TrendingDelevlopeRealm).filter(predicate)
//        default:
//            let predicate = NSPredicate(format: "typename CONTAINS %@", "month")
//            return realm.objects(TrendingDelevlopeRealm).filter(predicate)
//        }
//    }
//    
//    class func delete(type:Int) {
//        let res = select(type)
//        try! realm.write({ () -> Void in
//            realm.delete(res)
//        })
//    }
//}
//
////MARK: Realm Action
///// 对GitubStarsRealm进行操作
//class GithubStarsRealmAction{
//    
//    //插入数据
//    
//    /**
//    更新数据
//    
//    - parameter data:  数据
//    - parameter block: complete block
//    */
//    class func insertStars(starsModelArray:[GithubStarsRealm],callblocak:(Bool) -> Void){
//        do{
//            try realm.write({ () -> Void in
//                realm.add(starsModelArray, update: true)
//                callblocak(true)
//            })
//        }catch{
//            callblocak(false)
//        }
//        
//    }
//    /**
//     插入Trending数据
//     
//     - parameter data:  数据
//     - parameter block: complete block
//     */
//    class func insertStarTrending(type: Int,starsModel:GithubStarTrending,callblocak:(Bool) -> Void) {
//        
//        
//        let ms = NSDate().timeIntervalSince1970
//        switch type {
//        case 0:
//            starsModel.typename = "today" + String(ms)
//        case 1:
//            starsModel.typename = "week" + String(ms)
//        default:
//            starsModel.typename = "month" + String(ms)
//        }
//        do{
//            try realm.write({ () -> Void in
//                realm.add(starsModel, update: true)
//                callblocak(true)
//            })
//        }catch{
//            callblocak(false)
//        }
//    }
//    
//   
//    
//    class func selectTrengind(type: Int) -> Results<(GithubStarTrending)> {
//        switch type {
//        case 0:
//            let predicate = NSPredicate(format: "typename CONTAINS %@", "today")
//            return realm.objects(GithubStarTrending).filter(predicate)
//        case 1:
//            let predicate = NSPredicate(format: "typename CONTAINS %@", "week")
//            return realm.objects(GithubStarTrending).filter(predicate)
//        default:
//            let predicate = NSPredicate(format: "typename CONTAINS %@", "month")
//            return realm.objects(GithubStarTrending).filter(predicate)
//        }
//    }
//    
//    
//    class func deleteTrending(type: Int) {
//        let res = selectTrengind(type)
//        try! realm.write({ () -> Void in
//            realm.delete(res)
//        })
//    }
//    
//    
//    //选择数据
//    
//    /**
//    选取第一条数据
//    
//    - returns: 选择的结果
//    */
//    class func selectFirstStar() -> GithubStarsRealm?{
//        return realm.objects(GithubStarsRealm).first
//    }
//    /**
//     选择所有数据根据存入的顺序
//     
//     - returns: 选择的结果
//     */
//    class func selectStars() -> Results<(GithubStarsRealm)>{
//        return realm.objects(GithubStarsRealm)
//    }
//    /**
//     选择没有分组的Repository
//     
//     - returns: 选择结果
//     */
//    
//    class func selectStarsSortByUngrouped() -> Results<(GithubStarsRealm)>{
//        return realm.objects(GithubStarsRealm).filter("groupsNmae = nil").sorted("name")
//    }
//    /**
//     选择ALL Repository
//     
//     - returns: 选择结果
//     */
//    class func selectStarsSortByName()-> Results<(GithubStarsRealm)>{
//        
//        return realm.objects(GithubStarsRealm).sorted("name")
//    }
//    /**
//     选择项目的Readme 文件
//     
//     - parameter id: 项目的ID
//     
//     - returns: 选择结果
//     */
//    class func selectReadMe(id:Int) -> Results<GithubStarReadMe>{
//        let predicate = NSPredicate(format: "id = %d", id)
//        return realm.objects(GithubStarReadMe).filter(predicate)
//    }
//    /**
//     选择项目的Readme 文件html url
//     
//     - parameter id: 项目的ID
//     
//     - returns: 选择结果
//     */
//    class func selectReadMeHTMLUrl(id:Int) -> GithubStarReadMe? {
//        return realm.objects(GithubStarReadMe).filter("id=\(id)").first
//    }
//    /**
//     选择项目
//     
//     - parameter id: 项目id
//     
//     - returns: 选择结果
//     */
//    class func selectStarByID(id:Int) -> Results<GithubStarsRealm> {
//        return realm.objects(GithubStarsRealm).filter("id=\(id)")
//    }
//    
//    /**
//     根据分组选择项目
//     
//     - parameter name: 项目所属组
//     
//     - returns: 选择结果
//     */
//    
//    class func selectStarByGroupNameSortedByName(name: String) -> Results<GithubStarsRealm>{
//        let predicate = NSPredicate(format: "groupsNmae = %@", name)
//        return realm.objects(GithubStarsRealm).filter(predicate).sorted("name")
//    }
//    
//    //更新数据
//    class func updateStarOwnGroup(star:GithubStarsRealm,groupName:String,back:(Bool) -> Void){
//        
//        do{
//          try realm.write({ () -> Void in
//            star.groupsNmae = groupName
//            back(true)
//          })
//        }catch{
//            back(false)
//        }
//        
//    }
//    //删除数据
//}
//
//class GithubGroupRealmAction{
//    
//    class func insert(name: String,callbock:(Bool) -> Void){
//        let group = GithubGroupRealm(value: ["name":name,"count":0])
//        do{
//            try realm.write({ () -> Void in
//                realm.add(group)
//                callbock(true)
//            })
//        }catch{
//            callbock(false)
//        }
//    }
//    
//
//    
//    class func select() -> Results<(GithubGroupRealm)>{
//        return realm.objects(GithubGroupRealm).sorted("name")
//    }
//    
//    class func removeAgroup(name:GithubGroupRealm) {
//        try! realm.write {
//            realm.delete(name)
//        }
//    }
//    
//}
//
//
//
//


