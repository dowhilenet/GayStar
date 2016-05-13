//
//  TrendingStarRealm.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import RealmSwift
import Realm

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
        do {
            try RealmData.share.realm.write({
                RealmData.share.realm.add(star)
            })
            return !res
        } catch {
            return res
        }
    }
    /**
     根据类型筛选不同的热门库
     
     - parameter type: 类型参数
     
     - returns: 热门仓库
     */
    class func selectStarsBytype(type:Int64) -> [TrendingStarRealm] {
        return Array<TrendingStarRealm>(RealmData.share.realm.objects(TrendingStarRealm).filter(NSPredicate(format: "type = %@", NSNumber(longLong: type))))
    }
    /**
     根据热门项目的分类
     
     - parameter type: 类型
     
     - returns: true or  false
     */
    class func deleteAllStars(type: Int64) -> Bool {
        let res: Bool = false
        do {
            let deleteedRes = RealmData.share.realm.objects(TrendingStarRealm).filter(NSPredicate(format: "type = %@", NSNumber(longLong: type)))
            try RealmData.share.realm.write({
                RealmData.share.realm.delete(deleteedRes)
            })
            return !res
        }catch {
            return res
        }
        
    }
    
}