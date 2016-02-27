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
import Unbox
import RealmSwift
import SafariServices

class TrendingRepositionInfoViewController: UIViewController {
    
    var repositionModel: GithubStarTrending!
    var starReadMe: Results<GithubStarReadMe>!
    var readmeView: WKWebView!
    var html: String!
    var toolView: UIToolbar!
    var safari: SFSafariViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = repositionModel.name
        
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
        let tab1 = UIBarButtonItem(image: UIImage(named: "项目网站"), style: .Plain, target: self, action: "goHome")
        
        //README
        let tab2 = UIBarButtonItem(image: UIImage(named: "Group"), style: .Plain, target: self, action: "readMeOnGithub")
        
        //ISS
        let tab3 = UIBarButtonItem(image: UIImage(named: "GitHub主页"), style: .Plain, target: self, action: "onGithub")
        
        //User
        let tab4 = UIBarButtonItem(image: UIImage(named: "作者信息"), style: .Plain, target: self, action: "user")
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        toolView.items = [flexibleSpace,tab1,flexibleSpace,tab2,flexibleSpace,tab3,flexibleSpace,tab4,flexibleSpace]
        
        //获取这个项目的README 文件。
        let tryloadReadme = GithubStarsRealmAction.selectReadMe(repositionModel.id)
        if tryloadReadme.first?.id == nil{
            loadReadMe()
        }else{
            loadreadMefromRealm(repositionModel.id)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadReadMe() {
        ProgressHUD.show("Loading")
        Alamofire.request(GithubAPI.readme(name: repositionModel.fullName))
            .validate()
            .responseData { (response) -> Void in
                guard let data = response.data else {
                    self.load404()
                    return
                }
                let urlmodel:ReadMeDownModel? = Unbox(data)
                if let urlmodel =  urlmodel {
                    ReadMeDown.request(self.repositionModel.id, url: urlmodel.download_url, html_url: urlmodel.html_url, callback: { (success) -> Void in
                        if success {
                            self.loadreadMefromRealm(self.repositionModel.id)
                        }else {
                            self.load404()
                        }
                    })
                } else {
                    self.load404()
                }
        }
    }
    
    /**
     根据 ID 来请求数据库中的html 如果没有 加载 404
     
     - parameter id: 项目ID
     */
    
    private func loadreadMefromRealm(id:Int){
        
        self.starReadMe = GithubStarsRealmAction.selectReadMe(id)
        if self.starReadMe.first?.htmlString != nil{
            self.html = htmlheader(self.starReadMe.first!.htmlString)
            self.readmeView.loadHTMLString(self.html, baseURL: nil)
            ProgressHUD.dismiss()
        }else{
            self.load404()
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
        let homeUrl = repositionModel.homePage
        guard let homeurl = homeUrl else{
            ProgressHUD.showError("No Home Page")
            return
        }
        if homeurl.isEmpty{
            ProgressHUD.showError("No Home Page")
            return
        }
        showSafari(homeurl)
    }
    
    func readMeOnGithub(){
        let readmehtmlurl = GithubStarsRealmAction.selectReadMeHTMLUrl(repositionModel.id)
        guard let url = readmehtmlurl?.html_url else {
            ProgressHUD.showError("404")
            return
        }
        showSafari(url)
    }
    
    func onGithub(){
        let userurl = repositionModel.html
        showSafari(userurl)
    }
    
    func user(){
        let userurl = repositionModel.htmlURL
        showSafari(userurl)
    }
    
    func showSafari(url:String){
        safari = SFSafariViewController(URL: NSURL(string: url)!)
        presentViewController(safari, animated: true, completion: nil)
    }
}
