//
//  StarInformationViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/24.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import WebKit
import RealmSwift
import Unbox

class StarInformationViewController: UIViewController,PushStarProtocol{
    
    
    var item:GithubStarsRealm!
    var starReadMe:Results<GithubStarReadMe>!
    var webview:WKWebView!
    var html:String!
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        webview = WKWebView()
        webview.backgroundColor = UIColor.greenColor()
        self.view.addSubview(webview)
        webview.snp_makeConstraints { (make) -> Void in
        make.edges.equalTo(self.view)
        }
        pullView()
        //获取这个项目的README 文件。
        let tryloadReadme = GithubStarsRealmAction.selectReadMe(self.item.id)
        if tryloadReadme.first?.id == nil{
            ProgressHUD.show("Loading...")
            loadReadme()
        }else{
            loadreadMefromRealm(item.id)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    /**
     代理传值
     
     - parameter item: 用户选择的项目
     */
    func didSelectedStar(item:GithubStarsRealm){
        self.item = item
    }


    func pullView(){
        
    loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
    //圈圈颜色
    webview.scrollView.dg_setPullToRefreshFillColor(UIColor(red: 239.0/255.0, green: 95.0/255.0, blue: 49.0/255.0, alpha: 1.0))
    webview.scrollView.dg_setPullToRefreshBackgroundColor(webview.scrollView.backgroundColor!)
    
    webview.scrollView.dg_addPullToRefreshWithActionHandler({ () -> Void in
        //刷新当前仓库的状态
        let urlString = self.item.fullName
        let url = GithubAPI.repos(repos: urlString)
        Alamofire.request(url)
        .validate()
        .responseData({ (res) -> Void in
        guard let data = res.data,star:GithubStarsRealm = Unbox(data) else{
        ProgressHUD.showError("No Data")
                return
        }
        let stars = [star]
        GithubStarsRealmAction.insertStars(stars, callblocak: { (boole) -> Void in
            if boole{
                self.item = GithubStarsRealmAction.selectStarByID(self.item.id).first
                self.loadReadme()
            }
        })
        })
        self.webview.scrollView.dg_stopLoading()
        }, loadingView: loadingView)
    }
    
    deinit {
        webview.scrollView.dg_removePullToRefresh()
    }
    /**
     WKWebView 加载readme
     */
    private func loadReadme(){
        
        Alamofire.request(GithubAPI.readme(name: self.item.fullName))
        .validate()
        .responseData { (res) -> Void in
        guard let data                = res.data else {
                self.load404()
                ProgressHUD.dismiss()
                return
        }
        let urlmodel:ReadMeDownModel? = Unbox(data)
        if let urlmodel               = urlmodel{
        ReadMeDown.request(self.item.id, url: urlmodel.download_url, callback: { (boole) -> Void in
        if boole{
        self.loadreadMefromRealm(self.item.id)
        }else{
        self.load404()
        ProgressHUD.dismiss()
        }
        })
        }else{
        self.load404()
        ProgressHUD.dismiss()
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
            self.html = self.htmlheader(self.starReadMe.first!.htmlString)
            self.webview.loadHTMLString(self.html, baseURL: nil)
            ProgressHUD.dismiss()
        }else{
            self.load404()
            ProgressHUD.dismiss()
        }
    }
    
    /**
     404页面
     */
    private func load404(){
        let html404 = NSBundle.mainBundle().URLForResource("404", withExtension: "html")!
        self.html = try! NSString(contentsOfURL: html404, encoding: NSUTF8StringEncoding) as String
        self.webview.loadHTMLString(self.html, baseURL: nil)
    }
    
    
    
    /**
     html 的内容
     
     - parameter boday: body neirong
     
     - returns: 完整的html
     */
    
    private func htmlheader(boday:String) -> String{
        
        var  css:String{
            let star = "<style>"
            let end = "</style>"
            let cssfilePatch = NSBundle.mainBundle().pathForResource("bootstrap.min", ofType: "css")!
            let cssString = try! NSString(contentsOfFile: cssfilePatch, encoding:NSUTF8StringEncoding) as String
            
            let mycss = "<style>" + "  .container-fluid{margin:8px;}" + "</style>"
            
            return star + cssString + end + mycss
        }
        
        var markdwoncss:String{
            let star = "<style>"
            let end = "</style>"
            let cssfilePatch = NSBundle.mainBundle().pathForResource("markdown", ofType: "css")!
            let cssString = try! NSString(contentsOfFile: cssfilePatch, encoding:NSUTF8StringEncoding) as String
         
            return star + cssString + end
        }
        
        var javascript:String{
            let star = "<script>"
            let end = "</script>"
            let jsfilepatch = NSBundle.mainBundle().pathForResource("jquery.min", ofType: "js")!
            let jsString = try! NSString(contentsOfFile: jsfilepatch, encoding: NSUTF8StringEncoding) as String
            return star + jsString + end
        }
        
        let htmlhead = "<!DOCTYPE html><html><head><meta charset=\"UTF-8\">  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\">" + css + markdwoncss
        let htmbody = "</head><body>" + "<div class=\"container-fluid\"> <div class=\"row\"> <div class\"col-xs-12\">" + boday + "</div></div></div>"
        
        let scriptstar = "<script>" + "$(function(){$('img').addClass(\"img-responsive\");$('a').click(function(){return false})})"
        
        let htmlend = "</script></body></html>"
        
        return htmlhead + htmbody + javascript + scriptstar + htmlend
    }
}
