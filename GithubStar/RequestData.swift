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


enum TrendingRepositories:String{
    case ToDay = "?since=daily"
    case Week = "?since=weekly"
    case Monhly = "?since=monthly"
    
    var baseurl: String {
        return "https://github.com/trending"
    }

    //返回仓库的名字
     func getRepo(name:String?) ->[String]{

        var res = [String]()
        var url = ""
        
        if let name = name {
             url = baseurl + "/\(name)" + self.rawValue
        }else{
            url = baseurl + self.rawValue
        }
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
    
}

