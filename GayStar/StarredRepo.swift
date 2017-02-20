//
//  StarredRepo.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

//
//	✨StarredRepo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

struct StarredRepo: SwiftyJSONAble{
  
  var repo : Repo!
  var starredAt : String!
  
  
  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init?(fromJson json: JSON){
    if json.isEmpty{
      return nil
    }
    let repoJson = json["repo"]
    if !repoJson.isEmpty{
      repo = Repo(fromJson: repoJson)
    }
    starredAt = json["starred_at"].stringValue
  }
  
}

//
//	✨Repo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

struct Repo{
  
  var archiveUrl : String!
  var assigneesUrl : String!
  var blobsUrl : String!
  var branchesUrl : String!
  var cloneUrl : String!
  var collaboratorsUrl : String!
  var commentsUrl : String!
  var commitsUrl : String!
  var compareUrl : String!
  var contentsUrl : String!
  var contributorsUrl : String!
  var createdAt : String!
  var defaultBranch : String!
  var deploymentsUrl : String!
  var descriptionField : String!
  var downloadsUrl : String!
  var eventsUrl : String!
  var fork : Bool!
  var forks : Int!
  var forksCount : Int!
  var forksUrl : String!
  var fullName : String!
  var gitCommitsUrl : String!
  var gitRefsUrl : String!
  var gitTagsUrl : String!
  var gitUrl : String!
  var hasDownloads : Bool!
  var hasIssues : Bool!
  var hasPages : Bool!
  var hasWiki : Bool!
  var homepage : String!
  var hooksUrl : String!
  var htmlUrl : String!
  var id : Int!
  var issueCommentUrl : String!
  var issueEventsUrl : String!
  var issuesUrl : String!
  var keysUrl : String!
  var labelsUrl : String!
  var language : String!
  var languagesUrl : String!
  var mergesUrl : String!
  var milestonesUrl : String!
  var mirrorUrl : String!
  var name : String!
  var notificationsUrl : String!
  var openIssues : Int!
  var openIssuesCount : Int!
  var owner : Owner!
  var permissions : Permission!
  var privateField : Bool!
  var pullsUrl : String!
  var pushedAt : String!
  var releasesUrl : String!
  var size : Int!
  var sshUrl : String!
  var stargazersCount : Int!
  var stargazersUrl : String!
  var statusesUrl : String!
  var subscribersUrl : String!
  var subscriptionUrl : String!
  var svnUrl : String!
  var tagsUrl : String!
  var teamsUrl : String!
  var treesUrl : String!
  var updatedAt : String!
  var url : String!
  var watchers : Int!
  var watchersCount : Int!
  
  
  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init(fromJson json: JSON!){
    if json.isEmpty{
      return
    }
    archiveUrl = json["archive_url"].stringValue
    assigneesUrl = json["assignees_url"].stringValue
    blobsUrl = json["blobs_url"].stringValue
    branchesUrl = json["branches_url"].stringValue
    cloneUrl = json["clone_url"].stringValue
    collaboratorsUrl = json["collaborators_url"].stringValue
    commentsUrl = json["comments_url"].stringValue
    commitsUrl = json["commits_url"].stringValue
    compareUrl = json["compare_url"].stringValue
    contentsUrl = json["contents_url"].stringValue
    contributorsUrl = json["contributors_url"].stringValue
    createdAt = json["created_at"].stringValue
    defaultBranch = json["default_branch"].stringValue
    deploymentsUrl = json["deployments_url"].stringValue
    descriptionField = json["description"].stringValue
    downloadsUrl = json["downloads_url"].stringValue
    eventsUrl = json["events_url"].stringValue
    fork = json["fork"].boolValue
    forks = json["forks"].intValue
    forksCount = json["forks_count"].intValue
    forksUrl = json["forks_url"].stringValue
    fullName = json["full_name"].stringValue
    gitCommitsUrl = json["git_commits_url"].stringValue
    gitRefsUrl = json["git_refs_url"].stringValue
    gitTagsUrl = json["git_tags_url"].stringValue
    gitUrl = json["git_url"].stringValue
    hasDownloads = json["has_downloads"].boolValue
    hasIssues = json["has_issues"].boolValue
    hasPages = json["has_pages"].boolValue
    hasWiki = json["has_wiki"].boolValue
    homepage = json["homepage"].stringValue
    hooksUrl = json["hooks_url"].stringValue
    htmlUrl = json["html_url"].stringValue
    id = json["id"].intValue
    issueCommentUrl = json["issue_comment_url"].stringValue
    issueEventsUrl = json["issue_events_url"].stringValue
    issuesUrl = json["issues_url"].stringValue
    keysUrl = json["keys_url"].stringValue
    labelsUrl = json["labels_url"].stringValue
    language = json["language"].stringValue
    languagesUrl = json["languages_url"].stringValue
    mergesUrl = json["merges_url"].stringValue
    milestonesUrl = json["milestones_url"].stringValue
    mirrorUrl = json["mirror_url"].stringValue
    name = json["name"].stringValue
    notificationsUrl = json["notifications_url"].stringValue
    openIssues = json["open_issues"].intValue
    openIssuesCount = json["open_issues_count"].intValue
    let ownerJson = json["owner"]
    if !ownerJson.isEmpty{
      owner = Owner(fromJson: ownerJson)
    }
    let permissionsJson = json["permissions"]
    if !permissionsJson.isEmpty{
      permissions = Permission(fromJson: permissionsJson)
    }
    privateField = json["private"].boolValue
    pullsUrl = json["pulls_url"].stringValue
    pushedAt = json["pushed_at"].stringValue
    releasesUrl = json["releases_url"].stringValue
    size = json["size"].intValue
    sshUrl = json["ssh_url"].stringValue
    stargazersCount = json["stargazers_count"].intValue
    stargazersUrl = json["stargazers_url"].stringValue
    statusesUrl = json["statuses_url"].stringValue
    subscribersUrl = json["subscribers_url"].stringValue
    subscriptionUrl = json["subscription_url"].stringValue
    svnUrl = json["svn_url"].stringValue
    tagsUrl = json["tags_url"].stringValue
    teamsUrl = json["teams_url"].stringValue
    treesUrl = json["trees_url"].stringValue
    updatedAt = json["updated_at"].stringValue
    url = json["url"].stringValue
    watchers = json["watchers"].intValue
    watchersCount = json["watchers_count"].intValue
  }
  
}

//
//	Permission.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

struct Permission{
  
  var admin : Bool!
  var pull : Bool!
  var push : Bool!
  
  
  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init(fromJson json: JSON!){
    if json.isEmpty{
      return
    }
    admin = json["admin"].boolValue
    pull = json["pull"].boolValue
    push = json["push"].boolValue
  }
  
}

//
//	✨Owner.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

struct Owner{
  
  var avatarUrl : String!
  var eventsUrl : String!
  var followersUrl : String!
  var followingUrl : String!
  var gistsUrl : String!
  var gravatarId : String!
  var htmlUrl : String!
  var id : Int!
  var login : String!
  var organizationsUrl : String!
  var receivedEventsUrl : String!
  var reposUrl : String!
  var siteAdmin : Bool!
  var starredUrl : String!
  var subscriptionsUrl : String!
  var type : String!
  var url : String!
  
  
  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init(fromJson json: JSON!){
    if json.isEmpty{
      return
    }
    avatarUrl = json["avatar_url"].stringValue
    eventsUrl = json["events_url"].stringValue
    followersUrl = json["followers_url"].stringValue
    followingUrl = json["following_url"].stringValue
    gistsUrl = json["gists_url"].stringValue
    gravatarId = json["gravatar_id"].stringValue
    htmlUrl = json["html_url"].stringValue
    id = json["id"].intValue
    login = json["login"].stringValue
    organizationsUrl = json["organizations_url"].stringValue
    receivedEventsUrl = json["received_events_url"].stringValue
    reposUrl = json["repos_url"].stringValue
    siteAdmin = json["site_admin"].boolValue
    starredUrl = json["starred_url"].stringValue
    subscriptionsUrl = json["subscriptions_url"].stringValue
    type = json["type"].stringValue
    url = json["url"].stringValue
  }
  
}
