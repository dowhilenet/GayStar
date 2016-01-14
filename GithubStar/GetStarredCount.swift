//
//  GetStarredCount.swift
//  GITStare
//
//  Created by xiaolei on 16/1/9.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation

import Alamofire

class GetStarredCount{
    class func starredCount(callback:(Int?) -> Void){
        
        Alamofire.request(GithubAPI.starredCount)
            .validate()
            .responseData { (res) -> Void in
                let link = res.response!.allHeaderFields["Link"] as! String
                let range = link.rangeOfString(",", options: NSStringCompareOptions.BackwardsSearch)
                let last = String(link.characters.suffixFrom(range!.endIndex))
                let star = last.rangeOfString("&page=", options: NSStringCompareOptions.BackwardsSearch)!
                let end = last.rangeOfString(">;", options: NSStringCompareOptions.CaseInsensitiveSearch)!
                let page = String(last.substringWithRange(star.endIndex..<end.startIndex)).toInt()
                callback(page)
        }
    }
}