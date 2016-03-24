//
//  StarModel.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/22.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import SQLite
import SwiftyJSON

class ConnectingDataBase {
    private init(){}
    static let sharedObject = ConnectingDataBase()
    private  let document = NSHomeDirectory() + "/Documents"
    
    var db: Connection {
    
        var db:Connection!
        do {
            db = try Connection(document + "/db.sqlite3")
        }catch {
            print("Connecting Data Base Error")
        }
        return db
    }
}




protocol StarModelProtocol {
    static func createTable()
    static var table: Table { get }
    static func intsertStar(star:StarModelJsonProtocol) -> Bool
}

extension StarModelProtocol {
    
    static private var db:Connection { return ConnectingDataBase.sharedObject.db }
    static private var id: Expression<Int64> {return Expression<Int64>("id") }
    static private var stargazersCount: Expression<Int64> {return  Expression<Int64>("stargazersCount") }
    static private var name:Expression<String> { return Expression<String>("name") }
    static private var autherURL:Expression<String> { return Expression<String>("autherURL") }
    static private var fullName:Expression<String> { return Expression<String>("fullName") }
    static private var decription:Expression<String> { return Expression<String>("decription") }
    static private var language:Expression<String> { return  Expression<String>("language") }
    static private var avatarURL:Expression<String> { return Expression<String>("avatarURL") }
    static private var htmlURL: Expression<String> { return Expression<String>("htmlURL") }
    static private var homePage:Expression<String> { return Expression<String>("homePage") }
    static private var html:Expression<String> { return Expression<String>("html") }
    static private var autherName:Expression<String> { return Expression<String>("autherName") }
}



struct StarSQLiteModel: StarModelProtocol{
    
     static internal var table: Table {return Table("stars") }
    
     static private var groupsNmae: Expression<String?> { return Expression<String?>("groupsNmae") }
    
    static func createTable() {
        do {
            
            try db.run(table.create(temporary: false, ifNotExists: true, block: { (t) in
                t.column(id, primaryKey: true)
                t.column(stargazersCount)
                t.column(name)
                t.column(autherURL)
                t.column(fullName)
                t.column(decription)
                t.column(language)
                t.column(avatarURL)
                t.column(htmlURL)
                t.column(homePage)
                t.column(html)
                t.column(autherName)
                t.column(groupsNmae)
            }))

        }catch {
            print("创建表错误")
        }
    }
    
    static func intsertStar(star:StarModelJsonProtocol) -> Bool {
        let flag = false
        
        do{
            try db.run(table.insert(
                id <- star.idjson,
                stargazersCount <- star.stargazersCountjson,
                name <- star.namejson,
                autherURL <- star.autherURLjson,
                fullName <- star.fullNamejson,
                decription <- star.decriptionjson,
                language <- star.languagejson,
                avatarURL <- star.avatarURLjson,
                htmlURL <- star.htmlURLjson,
                homePage <- star.homePagejson,
                html <- star.htmljson,
                autherName <- star.autherNamejson
                ))
           
            return !flag
        }catch  {
            print("insert data error")
            return flag
        }
    }
}


extension StarSQLiteModel {
    
    static private func rowToStar(row:Row) -> StarDataModel {
        var star = StarDataModel()
        star.autherNamejson = row[autherName]
        star.autherURLjson = row[autherURL]
        star.avatarURLjson = row[avatarURL]
        star.decriptionjson = row[decription]
        star.fullNamejson = row[fullName]
        star.groupsName = row[groupsNmae]
        star.homePagejson = row[homePage]
        star.htmljson = row[html]
        star.htmlURLjson = row[htmlURL]
        star.idjson = row[id]
        star.stargazersCountjson = row[stargazersCount]
        star.languagejson = row[language]
        star.namejson = row[name]
        return star
    }
    
    static func selectStars() -> [StarDataModel] {
        var starArray = [StarDataModel]()
        do {
        
            let stars = Array(try db.prepare(table))
            stars.forEach({ (row) in
                let star = rowToStar(row)
                starArray.append(star)
            })
            return starArray
            
        }catch {
            print("Select Model Error")
            return starArray
        }
    }
    //选择没有被分组的star
    static func selectStarsByGroups() -> [StarDataModel] {
        var starArray = [StarDataModel]()
        do {
            let query = table.filter(groupsNmae == nil)
            let stars = try db.prepare(query)
            stars.forEach({ (row) in
                let star = rowToStar(row)
                starArray.append(star)
            })
            return starArray
            
        }catch {
            print("Select Model Error")
            return starArray
        }
    }
    
    static func selecCount(name: String) -> Int64 {
        var counts:Int64 = 0
        let query = table.filter(groupsNmae == name).count
        counts = Int64(db.scalar(query))
        return counts
    }
    
    static func selectStarByGroupName(name:String) -> [StarDataModel] {
        var stars = [StarDataModel]()
        
        do {
            let query = table.filter(groupsNmae == name).order(name)
            let results = try db.prepare(query)
            results.forEach({ (row) in
                let star = rowToStar(row)
                stars.append(star)
            })
        }catch let error as NSError {
            print("error : \(error.localizedDescription)")
        }
        
        return stars
    }
    
    static func deleteStarFromGroup(id: Int64) {
        do {
            
            try db.run(table.filter(self.id == id).update(groupsNmae <- nil))
            
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    static func updateStarGroup(id: Int64,name:String) {
        do {
            try db.run(table.filter(self.id == id).update(groupsNmae <- name))
        }catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
    }
}


struct TrendingStarSQLiteModel:StarModelProtocol {
    
    
    internal static var table = Table("TrendingStar")
    private static var typename = Expression<String>("typename")
    static func createTable(){
        do {
            
            try db.run(table.create(temporary: false, ifNotExists: true, block: { (t) in
                t.column(id)
                t.column(stargazersCount)
                t.column(name)
                t.column(autherURL)
                t.column(fullName)
                t.column(decription)
                t.column(language)
                t.column(avatarURL)
                t.column(htmlURL)
                t.column(homePage)
                t.column(html)
                t.column(autherName)
                t.column(typename)
            }))
            
        }catch {
            print("创建表错误")
        }
    }
    
    static func intsertStar(star:StarModelJsonProtocol) -> Bool {
        let flag = false
        
        guard let star = star as? TrendingStarModelProtocol else {
            print("type as error")
            return false
        }
        
        do {
            try db.run(table.insert(
                id <- star.idjson,
                stargazersCount <- star.stargazersCountjson,
                name <- star.namejson,
                autherURL <- star.autherURLjson,
                fullName <- star.fullNamejson,
                decription <- star.decriptionjson,
                language <- star.languagejson,
                avatarURL <- star.avatarURLjson,
                htmlURL <- star.htmlURLjson,
                homePage <- star.homePagejson,
                html <- star.htmljson,
                autherName <- star.autherNamejson,
                typename <- star.type
                ))
            return !flag
        }catch {
            print("insert data error")
            return flag
        }
        
    }
}

extension TrendingStarSQLiteModel {
    static private func rowToStar(row:Row) -> TrendingStarModel {
        var star = TrendingStarModel()
        star.autherNamejson = row[autherName]
        star.autherURLjson = row[autherURL]
        star.avatarURLjson = row[avatarURL]
        star.decriptionjson = row[decription]
        star.fullNamejson = row[fullName]
        star.type = row[typename]
        star.homePagejson = row[homePage]
        star.htmljson = row[html]
        star.htmlURLjson = row[htmlURL]
        star.idjson = row[id]
        star.stargazersCountjson = row[stargazersCount]
        star.languagejson = row[language]
        star.namejson = row[name]
        return star
    }
    
    static func selectStarsBytype(type:String) -> [TrendingStarModel] {
        var stars = [TrendingStarModel]()
        do {
            let query = table.filter(typename == type)
            let results = try db.prepare(query)
            results.forEach({ (row) in
                let star = rowToStar(row)
                stars.append(star)
            })
            return stars
        }catch {
            print("Select Model Error")
            return stars
        }
        
    }
    
    
    static func deleteAllStars() {
        do {
            try db.run(table.delete())
        }catch let error as NSError {
            print("删除数据错误:\(error.localizedDescription)")
        }
        
    }
}

struct StarReadMeSQLite {
    
    static private let table = Table("starreadme")
    static private let db = ConnectingDataBase.sharedObject.db
    
    static private let id = Expression<Int64>("id")
    static private let htmlValue = Expression<String?>("htmlValue")
    static private let htmlUrl = Expression<String?>("htmlUrl")
    
    static func createTable() {
        do {
            try db.run(table.create(temporary: false, ifNotExists: true, block: { (t) in
                t.column(id, primaryKey: true)
                t.column(htmlValue)
                t.column(htmlUrl)
            }))
        }catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
    
    static func insertReadMe(data:StarReadMe) -> Bool {
        let falg = false
        do {
            try db.run(table.insert(
                id <- data.id,
                htmlUrl <- data.readmeURL,
                htmlValue <- data.readmeValue
                ))
            return !falg
        }catch let error as NSError {
            print("inset readme error: \(error.localizedDescription)")
            return falg
        }
    }
    
    static func selectRreadMeByID(id:Int64) -> StarReadMe {
        var readme = StarReadMe()
        let query = table.filter(self.id == id)
        let row = db.pluck(query)
        guard let rowread = row else { return readme }
        readme.id = rowread[self.id]
        readme.readmeValue = rowread[htmlValue]
        readme.readmeURL = rowread[htmlUrl]
        return readme
    }
}

struct StarGroupSQLite {
    static private let table = Table("stargroup")
    static private let db = ConnectingDataBase.sharedObject.db
    
    static private let count = Expression<Int64>("count")
    static private let name = Expression<String>("name")
    
    static  func createTable() {
        do {
            try db.run(table.create(temporary: false, ifNotExists: true, block: { (t) in
                t.column(name, primaryKey: true)
                t.column(count)
            }))
        }catch let error as NSError {
            print("error:\(error.localizedDescription)")
        }
    }
    
    static  func insert(group:StarGroup) -> Bool{
        let flag = false
        do {
            try db.run(table.insert(
                    name <- group.name,
                    count <- group.count
                ))
            return !flag
        }catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
        return flag
    }
    
    static  func select() -> [StarGroup] {
        var groups = [StarGroup]()
        do {
            let query = table.order(name)
            let groupss = try db.prepare(query)
            groupss.forEach({ (row) in
                let group = StarGroup(name: row[name], count: row[count])
                groups.append(group)
            })
            
        }catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
        return groups
    }
    
    static func delete(name:String) {
        do {
            try db.run(table.filter(self.name == name).delete())
        }catch let error as NSError {
            print("error\(error.localizedDescription)")
        }
        
    }
}




