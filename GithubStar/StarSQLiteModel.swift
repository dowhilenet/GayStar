//
//  StarModel.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/22.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import SQLite
import SwiftyJSON

/// 连接数据库
class ConnectingDataBase {
    private init(){}
    static let sharedObject = ConnectingDataBase()
    private let document = NSHomeDirectory() + "/Documents"
    
    var db: Connection {
    
        var db:Connection!
        do {
            db = try Connection(document + "/db.sqlite3")
        }catch {
            print("Connecting Data Base Error")
        }
        return db
    }
    /**
     创建数据库中的表
     */
    static func createTables() {
        StarSQLiteModel.createTable()
        TrendingStarSQLiteModel.createTable()
        StarReadMeSQLite.createTable()
        StarGroupSQLite.createTable()
        TrendingDelevloperSQLite.createTale()
        UserSQLiteModel.createTable()
    }
}



/**
 *  数据库表的协议
 */
protocol StarModelProtocol {
    static func createTable()
    static var table: Table { get }
    static func intsertStar(star:StarModelJsonProtocol) -> Bool
}

// MARK: - Star 共有的属性
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


/**
 *  Star 的项目的数据模型
 */

struct StarSQLiteModel: StarModelProtocol{
         /// 表名
     static internal var table: Table {return Table("stars") }
             /// 扩展属性，项目所属的分组
     static private var groupsNmae: Expression<String?> { return Expression<String?>("groupsNmae") }
    /**
     表格的创建方法
     */
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
    /**
     stars 表插入数据
     
     - parameter star: Star 模型
     
     - returns: 插入成功的话返回 true
     */
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
    
    /**
     私有方法，将数据库中的一行数据转化成 Star 模型
     
     - parameter row: 数据库中的一行
     
     - returns: Star 模型
     */
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
    /**
     选取所有的项目中的Star
     
     - returns: 返回 Star 数组
     */
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
    /**
     选择没有被分组的star
     
     - returns: 没有被分组的Star 数组
     */
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
    
    /**
     某一个分组中的Star 数目
     
     - parameter name: 分组名称
     
     - returns: Star 数目
     */
    static func selecCount(name: String) -> Int64 {
        var counts:Int64 = 0
        let query = table.filter(groupsNmae == name).count
        counts = Int64(db.scalar(query))
        return counts
    }
    
    /**
     根据分组选出 Star
     
     - parameter name: 分组名称
     
     - returns: Star 数组
     */
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
    
    /**
     删除某一个分组下的Star
     
     - parameter id: Star ID
     */
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


/**
 *  热门项目表
 */
struct TrendingStarSQLiteModel:StarModelProtocol {
     /// 表名
    internal static var table = Table("TrendingStar")
        /// 扩展属性 类型名称
    private static var typename = Expression<Int64>("typename")
    /**
     建立表 方法
     */
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
    /**
     向表中插入Star
     
     - parameter star: Star Model
     
     - returns: Success －> True || Error -> False
     */
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
    /**
     私有方法 将数据库中的某一行转化成 TrendingStarModel
     
     - parameter row: 数据库中的行
     
     - returns: Trending Star Model
     */
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
    
    /**
     筛选数据通过 热门类型的不同
     
     - parameter type: 类型 ID
     
     - returns: Trending Star Model
     */
    static func selectStarsBytype(type:Int64) -> [TrendingStarModel] {
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
    
    /**
     删除所有的热门项目
     
     - parameter type: 要删除的类型
     */
    static func deleteAllStars(type: Int64) {
        do {
            try db.run(table.filter(typename == type).delete())
        }catch let error as NSError {
            print("删除数据错误:\(error.localizedDescription)")
        }
        
    }
}

/**
 *  Star Read Me 文件 缓存
 */
struct StarReadMeSQLite {
        /// 表的名字
    static private let table = Table("starreadme")
        /// 数据库
    static private let db = ConnectingDataBase.sharedObject.db
            /// 文件的id
    static private let id = Expression<Int64>("id")
        /// html 内容
    static private let htmlValue = Expression<String?>("htmlValue")
        /// read me 文件的 URL路径
    static private let htmlUrl = Expression<String?>("htmlUrl")
    /**
     创建表格
     */
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
    /**
     插入数据
     
     - parameter data: readme model
     
     - returns: true or false
     */
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
    /**
     根据项目的id 来筛选
     
     - parameter id: Star ID
     
     - returns: Star read me
     */
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
    
    /**
     更新 read me 文件
     
     - parameter id:     要跟新的id
     - parameter values: 要更新的内容
     
     - returns: true or false
     */
    static func updateReadMe(id: Int64, values: String) -> Bool {
        let falg = false
        do {
            try db.run(table.filter(self.id == id).update(htmlValue <- values))
            return !falg
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return falg
        }
    }
}

/**
 *  分组列表
 */
struct StarGroupSQLite {
        /// 表名
    static private let table = Table("stargroup")
            /// 数据库
    static private let db = ConnectingDataBase.sharedObject.db
        /// 分组所拥有的Star 数目
    static private let count = Expression<Int64>("count")
        /// 分组的名称
    static private let name = Expression<String>("name")
    /**
     建立表格
     */
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
    /**
     插入数据
     
     - parameter group: 分组model
     
     - returns: true or false
     */
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
    
    /**
     选择所有的分组
     
     - returns: 分组数组
     */
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
    
    /**
     删除某个分组
     
     - parameter name: 分组名称
     */
    static func delete(name:String) {
        do {
            try db.run(table.filter(self.name == name).delete())
        }catch let error as NSError {
            print("error\(error.localizedDescription)")
        }
        
    }
}

/**
 *  热门开发者
 */
struct TrendingDelevloperSQLite {
    
    private static let db = ConnectingDataBase.sharedObject.db
    private static let table = Table("trendingDeveloper")
    
    private static let githubName = Expression<String>("githubName")
    private static let imageURL = Expression<String>("imageURL")
    private static let fullName = Expression<String>("fullName")
    private static let githubURL = Expression<String>("githubURL")
    private static let repoURL = Expression<String>("repoURL")
    private static let repoName = Expression<String>("repoName")
    private static let repoDec = Expression<String>("repodec")
    private static let typeName = Expression<Int64>("typeName")
    
    static func createTale() {
        do{
            try db.run(table.create(temporary: false, ifNotExists: true, block: { (t) in
                t.column(githubName)
                t.column(imageURL)
                t.column(fullName)
                t.column(githubURL)
                t.column(repoURL)
                t.column(repoName)
                t.column(repoDec)
                t.column(typeName)
            }))
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func insert(developer: TrendingDeveloperModel) {
        do {
            try db.run(table.insert(
                githubName <- developer.githubname,
                imageURL <- developer.imageURL,
                fullName <- developer.fullName,
                githubURL <- developer.githubURL,
                repoURL <- developer.repoRUL,
                repoName <- developer.repoName,
                repoDec <- developer.repoDec,
                typeName <- developer.typename
                ))
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func selectByType(type: Int64) -> [TrendingDeveloperModel] {
        
        var devs = [TrendingDeveloperModel]()
        
        do {
            let res = try db.prepare(table.filter(typeName == type))
            res.forEach({ (row) in
                var dev = TrendingDeveloperModel()
                dev.fullName = row[fullName]
                dev.githubname = row[githubName]
                dev.githubURL = row[githubURL]
                dev.imageURL = row[imageURL]
                dev.repoDec = row[repoDec]
                dev.repoName = row[repoName]
                dev.repoRUL = row[repoURL]
                dev.typename = row[typeName]
                devs.append(dev)
            })
            return devs
        }catch let error as NSError {
            print(error.localizedDescription)
            return devs
        }
    }
    
    static func deleteByType(type: Int64) {
        do {
            try db.run(table.filter(typeName == type).delete())
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}




