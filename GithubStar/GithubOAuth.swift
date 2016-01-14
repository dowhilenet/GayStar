//
//  GithubOAuth.swift
//  GITStare
//
//  Created by xiaolei on 15/12/21.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import OAuthSwift
import SwiftyUserDefaults

class GithubOAuth{
    class func GithubOAuth(ViewController:UIViewController){
        
        let clientId = "af3689b7eef793657839"
        let clientSectet = "b2f4713ee30029079d036428f0ed45c6b44982a2"
        let oauthswift = OAuth2Swift(consumerKey: clientId, consumerSecret: clientSectet, authorizeUrl: "https://github.com/login/oauth/authorize",accessTokenUrl: "https://github.com/login/oauth/access_token", responseType: "code")
        let state = generateStateWithLength(20) as String
        let sfSafari = SafariURLHandler(viewController: ViewController)
        
        oauthswift.authorize_url_handler = sfSafari
        
        oauthswift.authorizeWithCallbackURL(NSURL(string: "GITStare://oauth-callback/github")!, scope: "user,repo", state: state,success: { (credential, response, parameters) -> Void in
                Defaults[.token] = credential.oauth_token
                Defaults.synchronize()
            }) { (error) -> Void in
            //Error
        }
        
    }
    
}



    
