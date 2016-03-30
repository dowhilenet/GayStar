//
//  UserModel.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/29.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import SwiftyJSON
import SQLite

struct UserSQLiteModel {
    
   static private let table = Table("user")
   static private let db = ConnectingDataBase.sharedObject.db
    
   static private let login = Expression<String>("login")
   static private let id = Expression<String>("id")
   static private let avatarURL = Expression<String>("avatar")
   static private let htmlurl = Expression<String>("html")
   static private let followersURL = Expression<String>("followersurl")
   static private let followingURL = Expression<String>("followingurl")
   static private let gistsURL = Expression<String>("gistsurl")
   static private let starredURL = Expression<String>("starredurl")
   static private let subscriptionsURL = Expression<String>("subs")
   static private let organiationsURL = Expression<String>("org")
   static private let reposURL = Expression<String>("reoposurl")
   static private let eventsURL = Expression<String>("evetsurl")
   static private let name = Expression<String>("name")
   static private let blog = Expression<String>("blog")
   static private let location = Expression<String>("location")
   static private let email = Expression<String>("emil")
   static private let publicRepos = Expression<String>("publirepos")
   static private let publicGists = Expression<String>("publicgits")
   static private let followers = Expression<String>("followers")
   static private let following = Expression<String>("following")
   static private let createdAt = Expression<String>("create")
   static private let updatedAt = Expression<String>("update")
    
    static func createTable() {
        do {
            try db.run(table.create(temporary: false, ifNotExists: true, block: { (t) in
                t.column(login)
                t.column(id, primaryKey: true)
                t.column(avatarURL)
                t.column(htmlurl)
                t.column(followersURL)
                t.column(followingURL)
                t.column(gistsURL)
                t.column(starredURL)
                t.column(subscriptionsURL)
                t.column(organiationsURL)
                t.column(reposURL)
                t.column(eventsURL)
                t.column(name)
                t.column(blog)
                t.column(location)
                t.column(email)
                t.column(publicRepos)
                t.column(publicGists)
                t.column(followers)
                t.column(following)
                t.column(createdAt)
                t.column(updatedAt)
            }))
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
    
    static func inserData(data: UserModel) {
        do {
            try db.run(table.insert(
                login <- data.login,
                id <- data.id,
                avatarURL <- data.avatarURL,
                htmlurl <- data.htmlurl,
                followersURL <- data.followersURL,
                followingURL <- data.followingURL,
                gistsURL <- data.gistsURL,
                starredURL <- data.starredURL,
                subscriptionsURL <- data.subscriptionsURL,
                organiationsURL <- data.organiationsURL,
                reposURL <- data.reposURL,
                eventsURL <- data.eventsURL,
                name <- data.name,
                blog <- data.blog,
                location <- data.location,
                email <- data.email,
                publicRepos <- data.publicRepos,
                publicGists <- data.publicGists,
                followers <- data.followers,
                following <- data.following,
                createdAt <- data.createdAt,
                updatedAt <- data.updatedAt
                ))
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func selectData() -> UserModel {
        var user = UserModel()
        guard let res =  db.pluck(table) else { return user}
        user.login = res[login]
        user.id = res[id]
        user.avatarURL = res[avatarURL]
        user.htmlurl = res[htmlurl]
        user.followersURL = res[followersURL]
        user.followingURL = res[followingURL]
        user.gistsURL = res[gistsURL]
        user.starredURL = res[starredURL]
        user.subscriptionsURL = res[subscriptionsURL]
        user.organiationsURL = res[organiationsURL]
        user.reposURL = res[reposURL]
        user.eventsURL = res[eventsURL]
        user.name = res[name]
        user.blog = res[blog]
        user.location = res[location]
        user.email = res[email]
        user.publicRepos = res[publicRepos]
        user.publicGists = res[publicGists]
        user.followers = res[followers]
        user.following = res[following]
        user.createdAt = res[createdAt]
        user.updatedAt = res[updatedAt]
        return user
    }
    
}


struct UserModel {
    var login = ""
    var id = ""
    var avatarURL = ""
    var htmlurl = ""
    var followersURL = ""
    var followingURL = ""
    var gistsURL = ""
    var starredURL = ""
    var subscriptionsURL = ""
    var organiationsURL = ""
    var reposURL = ""
    var eventsURL = ""
    var name = ""
    var blog = ""
    var location = ""
    var email = ""
    var publicRepos = ""
    var publicGists = ""
    var followers = ""
    var following = ""
    var createdAt = ""
    var updatedAt = ""
    init(){}
    init(data: NSData) {
        let json = JSON(data: data)[0]
        login = json["login"].stringValue
        id = json["id"].stringValue
        avatarURL = json["avatar_url"].stringValue
        htmlurl = json["html_url"].stringValue
        followersURL = json["followers_url"].stringValue
        followingURL = json["following_url"].stringValue
        gistsURL = json["gists_url"].stringValue
        starredURL = json["starred_url"].stringValue
        organiationsURL = json["organizations_url"].stringValue
        subscriptionsURL = json["subscriptions_url"].stringValue
        reposURL = json["repos_url"].stringValue
        eventsURL = json["events_url"].stringValue
        name = json["name"].stringValue
        blog = json["blog"].stringValue
        location = json["location"].stringValue
        email = json["email"].stringValue
        publicRepos = json["public_repos"].stringValue
        publicGists = json["public_gists"].stringValue
        followers = json["followers"].stringValue
        following = json["following"].stringValue
        createdAt = json["created_at"].stringValue
        updatedAt = json["updated_at"].stringValue
    }
}