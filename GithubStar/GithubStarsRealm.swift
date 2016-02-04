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

//MARK: GithubStarsRealm
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
    
    dynamic var html                  = ""
    
    dynamic var default_branch:String = ""
    
    dynamic var autherName            = ""
    dynamic var groupsNmae:String?    = nil
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
        htmlURL         = unboxer.unbox("owner.html_url")
        html            = unboxer.unbox("html_url")
        openIssuesCount = unboxer.unbox("open_issues_count")
        pushedTime      = unboxer.unbox("updated_at")
        homePage        = unboxer.unbox("homepage")
        name            = unboxer.unbox("name")
        autherURL       = unboxer.unbox("owner.url")
        id              = unboxer.unbox("id")
        default_branch  = unboxer.unbox("default_branch")
        autherName      = unboxer.unbox("owner.login")
    }
}


//MARK: GithubStarReadMe
class GithubStarReadMe: Object {
    dynamic var id         = 0
    dynamic var htmlString = ""
    dynamic var html_url:String?   = nil
    override static func primaryKey() -> String?{
        return "id"
    }
}


//MARK: GithubGroupRealm
class GithubGroupRealm: Object {
    
    dynamic var name       = ""
    dynamic var count      = 0
    
    override static func primaryKey() -> String?{
        return "name"
    }
    
    override static func indexedProperties() -> [String]{
        return ["name"]
    }
}



//MARK: Realm Action
/// 对GitubStarsRealm进行操作
class GithubStarsRealmAction{
    
    //插入数据
    
    /**
    更新数据
    
    - parameter data:  数据
    - parameter block: complete block
    */
    class func insertStars(starsModelArray:[GithubStarsRealm],callblocak:(Bool) -> Void){
        do{
            try realm.write({ () -> Void in
                realm.add(starsModelArray, update: true)
                callblocak(true)
            })
        }catch{
            callblocak(false)
        }
        
    }

    
    //选择数据
    
    /**
    选取第一条数据
    
    - returns: 选择的结果
    */
    class func selectFirstStar() -> GithubStarsRealm?{
        return realm.objects(GithubStarsRealm).first
    }
    /**
     选择所有数据根据存入的顺序
     
     - returns: 选择的结果
     */
    class func selectStars() -> Results<(GithubStarsRealm)>{
        return realm.objects(GithubStarsRealm)
    }
    /**
     选择没有分组的Repository
     
     - returns: 选择结果
     */
    class func selectStarsSortByName()-> Results<(GithubStarsRealm)>{
        
        return realm.objects(GithubStarsRealm).sorted("name")
    }
    class func selectStarsSortByUngrouped() -> Results<(GithubStarsRealm)>{
        return realm.objects(GithubStarsRealm).filter("groupsNmae = nil")
    }
    /**
     选择项目的Readme 文件
     
     - parameter id: 项目的ID
     
     - returns: 选择结果
     */
    class func selectReadMe(id:Int) -> Results<GithubStarReadMe>{
        let predicate = NSPredicate(format: "id = %d", id)
        return realm.objects(GithubStarReadMe).filter(predicate)
    }
    /**
     选择项目的Readme 文件html url
     
     - parameter id: 项目的ID
     
     - returns: 选择结果
     */
    class func selectReadMeHTMLUrl(id:Int) -> GithubStarReadMe? {
        return realm.objects(GithubStarReadMe).filter("id=\(id)").first
    }
    /**
     选择项目
     
     - parameter id: 项目id
     
     - returns: 选择结果
     */
    class func selectStarByID(id:Int) -> Results<GithubStarsRealm> {
        return realm.objects(GithubStarsRealm).filter("id=\(id)")
    }
    
    /**
     根据分组选择项目
     
     - parameter name: 项目所属组
     
     - returns: 选择结果
     */
    
    class func selectStarByGroupNameSortedByName(name: String) -> Results<GithubStarsRealm>{
        let predicate = NSPredicate(format: "groupsNmae = %@", name)
        return realm.objects(GithubStarsRealm).filter(predicate).sorted("name")
    }
    
    //更新数据
    class func updateStarOwnGroup(star:GithubStarsRealm,groupName:String,back:(Bool) -> Void){
        
        do{
          try realm.write({ () -> Void in
            star.groupsNmae = groupName
            back(true)
          })
        }catch{
            back(false)
        }
        
    }
    //删除数据
}

class GithubGroupRealmAction{
    
    class func insert(name: String,callbock:(Bool) -> Void){
        let group = GithubGroupRealm(value: ["name":name,"count":0])
        do{
            try realm.write({ () -> Void in
                realm.add(group)
                callbock(true)
            })
        }catch{
            callbock(false)
        }
    }
    
//    class func updateGroupCount(group:GithubGroupRealm){
//        try! realm.write({ () -> Void in
//            group.count = group.count + 1
//        })
//    }
    
    class func select() -> Results<(GithubGroupRealm)>{
        return realm.objects(GithubGroupRealm).sorted("name")
    }
    
    class func removeAgroup(name:GithubGroupRealm) {
        try! realm.write {
            realm.delete(name)
        }
    }
    
}


