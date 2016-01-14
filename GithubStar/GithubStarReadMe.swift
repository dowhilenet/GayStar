//
//  GithubStarReadMe.swift
//  GITStare
//
//  Created by xiaolei on 16/1/7.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation
import RealmSwift

class GithubStarReadMe: Object {
    dynamic var id         = 0
    dynamic var htmlString = ""
    override static func primaryKey() -> String?{
        return "id"
    }
}

class GithubStarReadMeCss: Object{
    dynamic var css = ""
}
