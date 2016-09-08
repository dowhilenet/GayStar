//
//  TrendingDelevloperRealm.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//



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
    class func insert(_ developer: TrendingDelevloperRealm) -> Bool {
        let res = false
        do {
            try RealmData.share.realm.write({ 
                RealmData.share.realm.add(developer)
            })
            return !res
        }catch {
            return res
        }
    }
    /**
     根据开发的ID来筛选开发的信息
     
     - parameter type: 开发者id
     
     - returns: 开发者模型
     */
    class func selectByType(_ type: Int64) -> [TrendingDelevloperRealm] {
        return Array<TrendingDelevloperRealm>(RealmData.share.realm.objects(TrendingDelevloperRealm).filter(NSPredicate(format: "typename = %@",NSNumber(value: type ))))
    }
    /**
     根据类型的ID 来删除某一类型下的所有热门开发者
     
     - parameter type: 类型ID
     
     - returns: 操作的结果 true or  false
     */
    class func deleteByType(_ type: Int64) -> Bool {
        let res = false
        return res
    }
    
}
