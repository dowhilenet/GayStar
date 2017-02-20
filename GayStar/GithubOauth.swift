//
//  GithubOauth.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import OAuthSwift

class GithubOauth {
  static let shared = GithubOauth()
  private init() {}
  
  var viewController: UIViewController!
  
  private func generateState(withLength len: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let length = UInt32(letters.characters.count)
    
    var randomString = ""
    for _ in 0..<len {
      let rand = arc4random_uniform(length)
      let idx = letters.index(letters.startIndex, offsetBy: Int(rand))
      let letter = letters.characters[idx]
      randomString += String(letter)
    }
    return randomString
  }
  
  func doOAuthGithub(viewController: UIViewController){
    let oauthswift = OAuth2Swift(
      consumerKey:    "af3689b7eef793657839",
      consumerSecret: "164f2df8ec5e912ca773ee5042920941221fd074",
      authorizeUrl:   "https://github.com/login/oauth/authorize",
      accessTokenUrl: "https://github.com/login/oauth/access_token",
      responseType:   "code"
    )
    self.viewController = viewController
    oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self.viewController, oauthSwift: oauthswift)
    let state = generateState(withLength: 20)
    let _ = oauthswift.authorize(
      withCallbackURL: URL(string: "GithubChat://oauth-callback")!, scope: "user,repo,notifications", state: state,
      success: { credential, response, parameters in
        print(parameters)
//        self.showTokenAlert(name: serviceParameters["name"], credential: credential)
    },
      failure: { error in
        print(error.description)
    }
    )

  }
  
}

