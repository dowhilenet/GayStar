//
//  RequestData.swift
//  GITStare
//
//  Created by xiaolei on 15/11/29.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import Alamofire
import Fuzi

enum TrendingRepositories:String{
    case ToDay = "?since=daily"
    case Week = "?since=weekly"
    case Monhly = "?since=monthly"
    
    var baseurl: String {
        return "https://github.com/trending"
    }

    //返回仓库的名字
    func getRepo(name:String?,back:([String]) -> Void) {

        var ress = [String]()
        var url = ""
        
        if let name = name {
             url = baseurl + "/\(name)" + self.rawValue
        }else{
            url = baseurl + self.rawValue
        }
        
        Alamofire.request(.GET, url)
        .responseData { (res) -> Void in
            guard let data = res.data , doc = try? HTMLDocument(data: data) else { back(ress); return }
            let repos = doc.xpath("//h3[@class='repo-list-name']")
            repos.forEach({ (element) -> () in
                guard let taga = element.firstChild(tag: "a") , var href = taga["href"] else { back(ress) ; return }
                href.removeAtIndex(href.startIndex)
                ress.append(href)
            })
            back(ress)
        }
    }
    
}

enum TrendingDevelopers:String{
    case ToDay = "?since=daily"
    case Week = "?since=weekly"
    case Monhly = "?since=monthly"
    
    var baseurl: String {
        return "https://github.com/trending/developers"
    }
    
    //返回仓库的名字
    func getRepo(type:Int64, name:String?,back: (Bool) -> Void ) {
        
        var url = ""
        var delevlopes = [TrendingDeveloperModel]()
        if let name = name {
            url = baseurl + "/\(name)" + self.rawValue
        }else{
            url = baseurl + self.rawValue
        }
        
        Alamofire.request(.GET, url)
            .responseData { (res) -> Void in
                
                guard let data = res.data , doc = try? HTMLDocument(data: data) else {
                    
                    back(false)
                    return }
                let repos = doc.css(".user-leaderboard-list-item")
                guard repos.count > 0 else { back(false) ; return}
                
                repos.forEach({ (element) -> () in
                    guard
                        let imageurl = element.css(".leaderboard-gravatar").first?["src"] ,
                        var githubName = element.css(".user-leaderboard-list-name").first?.firstChild(tag: "a")?["href"],
                        let fullName = element.css(".full-name").first?.stringValue ,
                        repoURL = element.css(".repo-snipit").first?["href"],
                        repoName = element.css(".repo").first?["title"],
                        repoDesc = element.css(".repo-snipit-description").first?.stringValue
                        else {  return }
                    githubName.removeAtIndex(githubName.startIndex)
                    let fullnameOne = fullName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    let fullnameTwo = fullnameOne.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "()"))
                    let repoDescOne = repoDesc.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    var dev = TrendingDeveloperModel()
                    dev.imageURL = imageurl
                    dev.githubname = githubName
                    dev.repoName = repoName
                    dev.fullName = fullnameTwo
                    dev.repoDec = repoDescOne
                    dev.githubURL = "https://github.com/" + githubName
                    dev.repoRUL = "https://github.com" + repoURL
                    dev.typename = type
                    delevlopes.append(dev)
                })//end for each
                
                guard delevlopes.count > 0 else { back(false) ;return }
                TrendingDelevloperSQLite.deleteByType(type)
                delevlopes.forEach({ (dev) in
                    TrendingDelevloperSQLite.insert(dev)
                })
                back(true)
                
        }
    }
    
}


