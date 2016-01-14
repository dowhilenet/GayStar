//
//  GithubStarsRealmAction.swift
//  GITStare
//
//  Created by xiaolei on 15/12/17.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation

import RealmSwift
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
    return realm.objects(GithubStarsRealm).sorted("number", ascending: true)
    }
    /**
     选择所有数据按名字排序
     
     - returns: 选择结果
     */
    class func selectStarsSortByName()-> Results<(GithubStarsRealm)>{
    return realm.objects(GithubStarsRealm).sorted("name")
    }
    
    /**
     选择项目的Readme 文件
     
     - parameter id: 项目的ID
     
     - returns: 选择结果
     */
    class func selectReadMe(id:Int) -> Results<GithubStarReadMe>{
    return realm.objects(GithubStarReadMe).filter("id=\(id)")
    }
    /**
     选择项目
     
     - parameter id: 项目id
     
     - returns: 选择结果
     */
    class func selectStarByID(id:Int) -> Results<GithubStarsRealm> {
    return realm.objects(GithubStarsRealm).filter("id=\(id)")
    }

    //更新数据
    //删除数据
}