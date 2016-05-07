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


/// Stared 项目
class StarRealm: StarBase {
    
    override static func primaryKey() -> String? {
        return "idjson"
    }
    
    //Star 的分组
    dynamic var groupsName: String = ""
    
    /**
     通过NSdata来初始化一个 StarRealm 数组
     
     - parameter data: NSData
     
     - returns: StarRealm 数组
     */
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
     更新项目所属分组
     
     - parameter star:      要更改的项目
     - parameter groupName: 分组名称
     
     - returns: true fale
     */
    class func updateGroup(star: StarRealm,groupName:String) -> Bool {
        let res = false
        do {
            try RealmData.share.realm.write({ 
                star.setValue(groupName, forKeyPath: "groupsName")
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
//    class func selecCount(name: String) -> Int {
//        let predicate = NSPredicate(format: "groupsName  = %@", name)
//        return RealmData.share.realm.objects(StarRealm).filter(predicate).count
//    }
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


