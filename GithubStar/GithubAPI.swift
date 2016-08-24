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
import OAuthSwift



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

    case feeds
    
    case me
}

extension GithubAPI:URLRequestConvertible{
    
    fileprivate var baseURL:String {return "https://api.github.com"}
    fileprivate var patch:String{
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
        case .feeds:
            return  "/feeds"
        case .me:
            return "/user"
        }
    }
    
    fileprivate var paraments:[String:AnyObject]?{
        switch self{
        case .user(_):
            return nil
        case .star(let page):
            return ["page":"\(page)"," as AnyObject as AnyObject as AnyObject as AnyObject as AnyObject as AnyObject as AnyObjectper_page":100]
        case .repos(_):
            return nil
        case .followers(_):
            return nil
        case .events(_):
            return nil
        case .readme(_):
            return nil
        case .starredCount:
            return ["per_page":1 as AnyObject]
        case .feeds:
            return  nil
        case .me:
            let token = Defaults[.token]
            guard let token1 = token else { return nil }
            return ["access_token":token1]
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let URL = Foundation.URL(string: baseURL)!
        let URLRequest = NSMutableURLRequest(url: URL.appendingPathComponent(patch))
        URLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        if let token = Defaults[.token]{
        URLRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: paraments).0
    }
}


class GithubOAuth{
    class func GithubOAuth(_ ViewController:UIViewController){
        
        let clientId = "af3689b7eef793657839"
        let clientSectet = "b2f4713ee30029079d036428f0ed45c6b44982a2"
        let oauthswift = OAuth2Swift(consumerKey: clientId, consumerSecret: clientSectet, authorizeUrl: "https://github.com/login/oauth/authorize",accessTokenUrl: "https://github.com/login/oauth/access_token", responseType: "code")
        let state = generateStateWithLength(20) as String
        let sfSafari = SafariURLHandler(viewController: ViewController)
        
        oauthswift.authorize_url_handler = sfSafari
        
        oauthswift.authorizeWithCallbackURL(URL(string: "GITStare://oauth-callback/github")!, scope: "user,repo", state: state,success: { (credential, response, parameters) -> Void in
            Defaults[.token] = credential.oauth_token
            Defaults.synchronize()
            UserRealm.requestDataAndInseret()
            }) { (error) -> Void in
                //Error
        }
        
    }
    
}


class GetStarredCount{
    class func starredCount(_ callback:@escaping (Int?) -> Void){
        
        Alamofire.request(GithubAPI.starredCount)
            .validate()
            .responseData { (res) -> Void in
                guard let response = res.response else { return }
                let link = response.allHeaderFields["Link"] as! String
                let range = link.rangeOfString(",", options: NSStringCompareOptions.BackwardsSearch)
                let last = String(link.characters.suffixFrom(range!.endIndex))
                let star = last.rangeOfString("&page=", options: NSStringCompareOptions.BackwardsSearch)!
                let end = last.rangeOfString(">;", options: NSStringCompareOptions.CaseInsensitiveSearch)!
                let page = String(last.substringWithRange(star.endIndex..<end.startIndex)).toInt()
                callback(page)
        }
    }
}


