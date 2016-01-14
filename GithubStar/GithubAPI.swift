//
//  GithubAPI.swift
//  GITStare
//
//  Created by xiaolei on 15/11/23.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire
/**
 请求目标
 
 - star: 请求Star
 */
enum GithubAPI{
    /**
     *  请求用户Star信息
     *
     *  @param user:String 用户名
     *  @param page:String 第几页信息
     *
     *  @return URL
     */
    case star(page:String)
    /**
     *  请求用户信息
     *
     *  @param user:String 用户名
     *
     *  @return JOSN
     */
    case user(user:String)
    /**
     *  请求仓库
     *
     *  @param user:String  用户名
     *  @param repos:String 仓库名
     *
     *  @return JOSN
     */
    case repos(repos:String)
    /**
     *  请求Followers
     *
     *  @param users:String 用户名
     *
     *  @return JOSN
     */
    case followers(users:String)
    /**
     *  请求用户最近events
     *
     *  @param user:String name
     *
     *  @return JOSN
     */
    case events(user:String)
    
    case readme(name:String)
    
    case starredCount
    
  
}

extension GithubAPI:URLRequestConvertible{
    
    private var baseURL:String {return "https://api.github.com"}
    private var patch:String{
        switch self{
        case .star:
            return "/user/starred"
        case .user(let user):
            return "/users/\(user)"
        case .repos(let repo):
            return "/repos/\(repo)"
        case .followers(let user):
            return "/users/\(user)/followers"
        case .events(let user):
            return "/users/\(user)/events"
        case .readme(let name):
            return "/repos/\(name)/readme"
        case .starredCount:
            return "/user/starred"
        }
    }
    
    private var paraments:[String:AnyObject]?{
        switch self{
        case .user(_):
            return nil
        case .star(let page):
            return ["page":"\(page)","per_page":100]
        case .repos(_):
            return nil
        case .followers(_):
            return nil
        case .events(_):
            return nil
        case .readme(_):
            return nil
        case .starredCount:
            return ["per_page":1]
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let URL = NSURL(string: baseURL)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(patch))
        URLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        if let token = Defaults[.token]{
        URLRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: paraments).0
    }
}




