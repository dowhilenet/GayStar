//
//  StarGroupRealm.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//



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
    class func insert(_ group:StarGroupRealm) -> Bool {
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
    class func deleteGroup(_ name:String) -> Bool {
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
