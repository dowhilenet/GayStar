//
//  GitubStars.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/22.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class GitubStars: Star {

// Insert code here to add functionality to your managed object subclass
      func initData(jsonData:JSON) {
        id = jsonData["id"].number
        openIssuesCount = jsonData["open_issues_count"].number
        forksCount = jsonData["forks_count"].number
        stargazersCount = jsonData["stargazers_count"].number
        name = jsonData["name"].stringValue
        autherURL = jsonData["owner","url"].stringValue
        fullName = jsonData["full_name"].stringValue
        decription = jsonData["description"].string
        language = jsonData["language"].string
        avatarURL = jsonData["owner","avatar_url"].stringValue
        htmlURL = jsonData["owner","html_url"].stringValue
        pushedTime = jsonData["updated_at"].stringValue
        homePage = jsonData["homepage"].string
        html = jsonData["html_url"].stringValue
        default_branch = jsonData["default_branch"].stringValue
        autherName = jsonData["owner","login"].stringValue
    }
}
