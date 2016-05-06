//
//  StarReadMeRealm.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import RealmSwift

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