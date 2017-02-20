//
//  CurrentUser.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

//
//	CurrentUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

struct CurrentUser: SwiftyJSONAble{
  
  var avatarUrl : String!
  var bio : String!
  var blog : String!
  var collaborators : Int!
  var company : String!
  var createdAt : String!
  var diskUsage : Int!
  var email : String!
  var eventsUrl : String!
  var followers : Int!
  var followersUrl : String!
  var following : Int!
  var followingUrl : String!
  var gistsUrl : String!
  var gravatarId : String!
  var hireable : String!
  var htmlUrl : String!
  var id : Int!
  var location : String!
  var login : String!
  var name : String!
  var organizationsUrl : String!
  var ownedPrivateRepos : Int!
  var plan : Plan!
  var privateGists : Int!
  var publicGists : Int!
  var publicRepos : Int!
  var receivedEventsUrl : String!
  var reposUrl : String!
  var siteAdmin : Bool!
  var starredUrl : String!
  var subscriptionsUrl : String!
  var totalPrivateRepos : Int!
  var twoFactorAuthentication : Bool!
  var type : String!
  var updatedAt : String!
  var url : String!
  
  
  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init?(fromJson json: JSON){
    if json.isEmpty{
      return nil
    }
    avatarUrl = json["avatar_url"].stringValue
    bio = json["bio"].stringValue
    blog = json["blog"].stringValue
    collaborators = json["collaborators"].intValue
    company = json["company"].stringValue
    createdAt = json["created_at"].stringValue
    diskUsage = json["disk_usage"].intValue
    email = json["email"].stringValue
    eventsUrl = json["events_url"].stringValue
    followers = json["followers"].intValue
    followersUrl = json["followers_url"].stringValue
    following = json["following"].intValue
    followingUrl = json["following_url"].stringValue
    gistsUrl = json["gists_url"].stringValue
    gravatarId = json["gravatar_id"].stringValue
    hireable = json["hireable"].stringValue
    htmlUrl = json["html_url"].stringValue
    id = json["id"].intValue
    location = json["location"].stringValue
    login = json["login"].stringValue
    name = json["name"].stringValue
    organizationsUrl = json["organizations_url"].stringValue
    ownedPrivateRepos = json["owned_private_repos"].intValue
    let planJson = json["plan"]
    if !planJson.isEmpty{
      plan = Plan(fromJson: planJson)
    }
    privateGists = json["private_gists"].intValue
    publicGists = json["public_gists"].intValue
    publicRepos = json["public_repos"].intValue
    receivedEventsUrl = json["received_events_url"].stringValue
    reposUrl = json["repos_url"].stringValue
    siteAdmin = json["site_admin"].boolValue
    starredUrl = json["starred_url"].stringValue
    subscriptionsUrl = json["subscriptions_url"].stringValue
    totalPrivateRepos = json["total_private_repos"].intValue
    twoFactorAuthentication = json["two_factor_authentication"].boolValue
    type = json["type"].stringValue
    updatedAt = json["updated_at"].stringValue
    url = json["url"].stringValue
  }
  
}


struct Plan{
  
  var collaborators : Int!
  var name : String!
  var privateRepos : Int!
  var space : Int!
  
  
  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init(fromJson json: JSON!){
    if json.isEmpty{
      return
    }
    collaborators = json["collaborators"].intValue
    name = json["name"].stringValue
    privateRepos = json["private_repos"].intValue
    space = json["space"].intValue
  }
  
}
