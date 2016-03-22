//
//  TrendingDevelopinfoViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/27.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
//import RealmSwift

class TrendingDevelopinfoViewController: UIViewController {

    let webview = WKWebView()
//    var dev: TrendingDelevlopeRealm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = dev.fullName
        view.addSubview(webview)
        webview.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
//        webview.loadRequest(NSURLRequest(URL: NSURL(string: dev.githubURL)!))
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
