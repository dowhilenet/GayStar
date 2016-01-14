//
//  RequestData.swift
//  GITStare
//
//  Created by xiaolei on 15/11/29.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import Ji
import Alamofire
import Unbox
import Haneke

enum TrendingRepositories:String{
    case ToDay = "https://github.com/trending?since=daily"
    case Week = "https://github.com/trending?since=weekly"
    case Monhly = "https://github.com/trending?since=monthly"
//   
//    //请求数据并缓存
//     func getTrendingRepositories(lan:String){
//        let url = self.rawValue + "&l=\(lan)"
//        let resName = getRepo(url)
//        requestStarsTrend(resName, url: url)
//    }
//    //返回数据
//    func cacheTrendingRepositories(lan:String,bloack:(NSData?) -> Void){
//        let cache = Shared.dataCache
//        let key = self.rawValue + "&l=\(lan)"
//        cache.fetch(key: key).onSuccess { (data) -> () in
//           bloack(data)
//        }
//        .onFailure { (_) -> () in
//            bloack(nil)
//        }
//    }
    //返回仓库的名字
     func getRepo(url:String) ->[String]{

        var res = [String]()
        

        guard let jiDoc = Ji(htmlURL: NSURL(string: url)!) ,let repos = jiDoc.xPath("//h3[@class='repo-list-name']") else{
            return res
        }
        repos.forEach { (node) -> () in
            if let aHref = node.firstChildWithName("a")?.attributes,var ahrefValue = aHref["href"]{
                ahrefValue.removeAtIndex(ahrefValue.startIndex)
                
                res.append(ahrefValue)
            }
        }
        
        return res
    }
    
//    private func requestStarsTrend(res:[String],url:String){
//        res.forEach { (res) -> () in
//        Alamofire.request(GithubAPI.repos(repos: res))
//        .validate()
//        .responseData({ (response)-> Void in
//            guard let data = response.data else{
//                return
//            }
//            let cache = Shared.dataCache
//            cache.set(value: data, key: url)
//        })
//        }
//    }
 
    
}

