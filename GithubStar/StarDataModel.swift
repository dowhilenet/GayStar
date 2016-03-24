//
//  StarDataModel.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/23.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import SwiftyJSON

protocol StarModelJsonProtocol {
    var idjson: Int64 {get set}
    var stargazersCountjson: Int64 {get set}
    var namejson: String {get set}
    var autherURLjson: String {get set}
    var fullNamejson: String {get set}
    var decriptionjson: String {get set}
    var languagejson: String {get set}
    var avatarURLjson: String {get set}
    var htmlURLjson: String {get set}
    var homePagejson: String {get set}
    var htmljson: String {get set}
    var autherNamejson: String {get set}
}


protocol TrendingStarModelProtocol: StarModelJsonProtocol {
    var type: String {get set}
}

struct TrendingStarModel:TrendingStarModelProtocol {
    
    var idjson: Int64 = 0
    var stargazersCountjson: Int64 = 0
    var namejson: String = ""
    var autherURLjson: String = ""
    var fullNamejson: String = ""
    var decriptionjson: String = ""
    var languagejson: String = ""
    var avatarURLjson: String = ""
    var htmlURLjson: String = ""
    var homePagejson: String = ""
    var htmljson: String = ""
    var autherNamejson: String = ""
    var type: String = ""
    
    init(){}
    
    init(jsonData: JSON,type: String){
        idjson = jsonData["id"].int64!
        stargazersCountjson = jsonData["stargazers_count"].int64!
        namejson = jsonData["name"].stringValue
        autherURLjson = jsonData["owner","url"].stringValue
        fullNamejson = jsonData["full_name"].stringValue
        decriptionjson = jsonData["description"].stringValue
        languagejson = jsonData["language"].stringValue
        avatarURLjson = jsonData["owner","avatar_url"].stringValue
        htmlURLjson = jsonData["owner","html_url"].stringValue
        homePagejson = jsonData["homepage"].stringValue
        htmljson = jsonData["html_url"].stringValue
        autherNamejson = jsonData["owner","login"].stringValue
        self.type = type
    }
    
    
    static func initStarArray(data: NSData,type: String) -> [TrendingStarModel] {
        var stars = [TrendingStarModel]()
        let jsonarray = JSON(data: data).arrayValue
        jsonarray.forEach { (data) in
            let star = TrendingStarModel(jsonData: data,type: type)
            stars.append(star)
        }
        return stars
    }
    
}
protocol StaredDataModel: StarModelJsonProtocol {
    var groupsName: String? {get set}
}

struct StarDataModel:StaredDataModel {
 
    var groupsName: String?
    var idjson: Int64 = 0
    var stargazersCountjson: Int64 = 0
    var namejson: String = ""
    var autherURLjson: String = ""
    var fullNamejson: String = ""
    var decriptionjson: String = ""
    var languagejson: String = ""
    var avatarURLjson: String = ""
    var htmlURLjson: String = ""
    var homePagejson: String = ""
    var htmljson: String = ""
    var autherNamejson: String = ""
    
    init(){}
    
    init(jsonData: JSON){
        idjson = jsonData["id"].int64!
        stargazersCountjson = jsonData["stargazers_count"].int64!
        namejson = jsonData["name"].stringValue
        autherURLjson = jsonData["owner","url"].stringValue
        fullNamejson = jsonData["full_name"].stringValue
        decriptionjson = jsonData["description"].stringValue
        languagejson = jsonData["language"].stringValue
        avatarURLjson = jsonData["owner","avatar_url"].stringValue
        htmlURLjson = jsonData["owner","html_url"].stringValue
        homePagejson = jsonData["homepage"].stringValue
        htmljson = jsonData["html_url"].stringValue
        autherNamejson = jsonData["owner","login"].stringValue
    }
    
    
    static func initStarArray(data: NSData) -> [StarDataModel] {
        var stars = [StarDataModel]()
        let jsonarray = JSON(data: data).arrayValue
        jsonarray.forEach { (data) in
            let star = StarDataModel(jsonData: data)
            stars.append(star)
        }
        return stars
    }
}


struct StarReadMe {
    var id: Int64 = 0
    var readmeValue: String?
    var readmeURL: String?
}

struct StarGroup {
    var name = ""
    var count:Int64 = 0
    
    init(name:String,count:Int64) {
        self.name = name
        self.count = count
    }
    
    init(name:String) {
        let counts = StarSQLiteModel.selecCount(name)
        self.init(name: name,count:counts)
    }
}

