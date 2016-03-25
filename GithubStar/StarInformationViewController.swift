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
import SafariServices
import SwiftyJSON

class StarInformationViewController: UIViewController{
    
    var item: StarDataModel!
    var starReadMe: StarReadMe!
    var webview: WKWebView!
    var html: String!
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var toolView: UIToolbar!
    var safari: SFSafariViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //配置视图
        configView()
        //下拉刷新控件的配置
        pullView()
        
        starReadMe = StarReadMeSQLite.selectRreadMeByID(item.idjson)
        if starReadMe.readmeValue == nil {
            loadReadme()
        }else {
            loadreadMefromRealm(item.idjson)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    //配置视图
    func configView(){
        
        self.title = "README.md"
        webview = WKWebView()
        self.view.addSubview(webview)
        webview.snp_makeConstraints { (make) -> Void in
            make.top.leading.trailing.equalTo(self.view)
        }
        webview.scrollView.alwaysBounceHorizontal = false
        
        toolView = UIToolbar()
        self.view.addSubview(toolView)
        toolView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(webview.snp_bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        //Home
        let tab1 = UIBarButtonItem(image: UIImage(named: "项目网站"), style: .Plain, target: self, action: #selector(StarInformationViewController.goHome))
        
        //README
        let tab2 = UIBarButtonItem(image: UIImage(named: "Group"), style: .Plain, target: self, action: #selector(StarInformationViewController.readMeOnGithub))
        
        //ISS
        let tab3 = UIBarButtonItem(image: UIImage(named: "GitHub主页"), style: .Plain, target: self, action: #selector(StarInformationViewController.onGithub))
        
        //User
        let tab4 = UIBarButtonItem(image: UIImage(named: "作者信息"), style: .Plain, target: self, action: #selector(StarInformationViewController.user))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        toolView.items = [flexibleSpace,tab1,flexibleSpace,tab2,flexibleSpace,tab3,flexibleSpace,tab4,flexibleSpace]
    }

    func pullView(){
        //圈圈颜色
    loadingView.tintColor = PullToRefreshTintColor
    webview.scrollView.dg_setPullToRefreshFillColor(PullToRefreshFillColor)
    webview.scrollView.dg_setPullToRefreshBackgroundColor(webview.scrollView.backgroundColor!)
    
    webview.scrollView.dg_addPullToRefreshWithActionHandler({ () -> Void in
        //刷新当前仓库的Readme
            self.loadReadme()
            self.webview.scrollView.dg_stopLoading()
        }, loadingView: loadingView)
    }
    
    deinit {
        webview.scrollView.dg_removePullToRefresh()
    }
    /**
     WKWebView 加载readme
     */
     func loadReadme(){
        ProgressHUD.show("Loading")
        //获取到 readme下载地址
        Alamofire.request(GithubAPI.readme(name: item.fullNamejson)).validate().responseData { (res) in
            guard let data = res.data else { self.load404(); return}
            let model = ReadMeDownModel(unboxer: data)
            ReadMeDown.request(self.item.idjson, url: model.download_url, html_url: model.html_url, callback: { (res) in
                if res {
                    self.loadreadMefromRealm(self.item.idjson)
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
    
     func loadreadMefromRealm(id:Int64){
        starReadMe = StarReadMeSQLite.selectRreadMeByID(id)
        if starReadMe.readmeValue != nil {
            html = htmlheader(starReadMe.readmeValue!)
            webview.loadHTMLString(html, baseURL: nil)
            ProgressHUD.dismiss()
            
        }else {
            load404()
        }
    }
    
    /**
     404页面
     */
    private func load404(){
        let html404 = NSBundle.mainBundle().URLForResource("404", withExtension: "html")!
        html = try! NSString(contentsOfURL: html404, encoding: NSUTF8StringEncoding) as String
        webview.loadHTMLString(html, baseURL: nil)
        ProgressHUD.dismiss()
        
    }
}

//MARK: SFSafariViewControllerDelegate
extension StarInformationViewController:SFSafariViewControllerDelegate{
    
    func safariViewControllerDidFinish(controller: SFSafariViewController){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
//MARK: Function
extension StarInformationViewController{
    
    func goHome(){
        let homeUrl = item.homePagejson
        showSafari(homeUrl)
    }
    
    func readMeOnGithub(){
        let url = starReadMe.readmeURL
        showSafari(url)
    }
    
    func onGithub(){
        let userurl = item.htmljson
        showSafari(userurl)
    }
    
    func user(){
        let userurl = item.htmlURLjson
        showSafari(userurl)
    }
    
    func showSafari(url:String?){
        guard let url = url else { ProgressHUD.showError("404") ;return }
        guard url != " " else { ProgressHUD.showError("404") ;return }
        guard let _url = NSURL(string: url) else { ProgressHUD.showError("404") ;return }
        safari = SFSafariViewController(URL: _url)
        presentViewController(safari, animated: true, completion: nil)
    }
    
}


