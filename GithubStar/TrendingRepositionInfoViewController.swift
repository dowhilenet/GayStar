//
//  TrendingRepositionInfoViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/27.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import Alamofire
import SafariServices

class TrendingRepositionInfoViewController: UIViewController {
    
    var repositionModel: TrendingStarModel!
    var starReadMe: StarReadMe!
    var readmeView: WKWebView!
    var html: String!
    var toolView: UIToolbar!
    var safari: SFSafariViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = repositionModel.namejson
        
        readmeView = WKWebView()
        self.view.addSubview(readmeView)
        readmeView.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(self.view)
        }
        
        toolView = UIToolbar()
        self.view.addSubview(toolView)
        toolView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(readmeView.snp_bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        //Home
        let tab1 = UIBarButtonItem(image: UIImage(named: "项目网站"), style: .Plain, target: self, action: #selector(TrendingRepositionInfoViewController.goHome))
        
        //README
        let tab2 = UIBarButtonItem(image: UIImage(named: "Group"), style: .Plain, target: self, action: #selector(TrendingRepositionInfoViewController.readMeOnGithub))
        
        //ISS
        let tab3 = UIBarButtonItem(image: UIImage(named: "GitHub主页"), style: .Plain, target: self, action: #selector(TrendingRepositionInfoViewController.onGithub))
        
        //User
        let tab4 = UIBarButtonItem(image: UIImage(named: "作者信息"), style: .Plain, target: self, action: #selector(TrendingRepositionInfoViewController.user))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        toolView.items = [flexibleSpace,tab1,flexibleSpace,tab2,flexibleSpace,tab3,flexibleSpace,tab4,flexibleSpace]
        
        //获取这个项目的README 文件。
        let readme = StarReadMeSQLite.selectRreadMeByID(repositionModel.idjson)
        if readme.readmeValue == nil {
            loadReadMe()
        }else {
            loadreadMefromRealm(repositionModel.idjson)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadReadMe() {
        ProgressHUD.show("Loading")
        StarRequestHelper.readMe.requestReadMeFile(repositionModel.fullNamejson) { (readme) in
            guard let readme = readme else { self.load404(); return}
            ReadMeDown.request(self.repositionModel.idjson, url: readme.download_url, html_url: readme.html_url, callback: { (res) in
                if res {
                    self.loadreadMefromRealm(self.repositionModel.idjson)
                }else {
                    self.load404()
                }
            })
        }
    }
    
    /**
     根据 ID 来请求数据库中的html 如果没有 加载 404
     
     - parameter id: 项目ID
     */
    
    private func loadreadMefromRealm(id:Int64){
        
        starReadMe = StarReadMeSQLite.selectRreadMeByID(id)
        if starReadMe.readmeValue == nil {
            load404()
        }else {
            html = htmlheader(starReadMe.readmeValue!)
            readmeView.loadHTMLString(html, baseURL: nil)
            ProgressHUD.dismiss()
        }
    }
    
    /**
     404页面
     */
    private func load404(){
        let html404 = NSBundle.mainBundle().URLForResource("404", withExtension: "html")!
        self.html = try! NSString(contentsOfURL: html404, encoding: NSUTF8StringEncoding) as String
        self.readmeView.loadHTMLString(self.html, baseURL: nil)
        ProgressHUD.dismiss()
    }
    
    
    func goHome(){
        let homeUrl = repositionModel.homePagejson
        showSafari(homeUrl)
    }
    
    func readMeOnGithub(){
        let url = starReadMe.readmeURL
        if url == nil {
            ProgressHUD.showError("404")
            return
        }else {
            showSafari(url!)
        }

    }
    
    func onGithub(){
        let userurl = repositionModel.htmljson
        showSafari(userurl)
    }
    
    func user(){
        let userurl = repositionModel.htmlURLjson
        showSafari(userurl)
    }
    
    func showSafari(url:String){
        guard url == " " else { ProgressHUD.showError("404") ; return }
        let url = NSURL(string: url)
        guard let URL = url else { ProgressHUD.showError("404") ; return }
        safari = SFSafariViewController(URL: URL)
        presentViewController(safari, animated: true, completion: nil)
    }
}
