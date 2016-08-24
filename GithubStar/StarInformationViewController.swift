//
//  StarInformationViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/12/24.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import SafariServices

class StarInformationViewController: UIViewController{
    
    var item: StarRealm!
    var starReadMe: StarReadMeRealm!
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
        
        guard let _ = StarReadMeRealm.selectRreadMeByID(self.item.idjson) else {
            //如果本地数据库没有的话，从网络获取
            loadReadme()
            return
        }
        loadreadMefromRealm(item.idjson)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftNotice.clear()
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
        let tab1 = UIBarButtonItem(image: UIImage(named: "项目网站"), style: .plain, target: self, action: #selector(StarInformationViewController.goHome))
        
        //README
        let tab2 = UIBarButtonItem(image: UIImage(named: "Group"), style: .plain, target: self, action: #selector(StarInformationViewController.readMeOnGithub))
        
        //ISS
        let tab3 = UIBarButtonItem(image: UIImage(named: "GitHub主页"), style: .plain, target: self, action: #selector(StarInformationViewController.onGithub))
        
        //User
        let tab4 = UIBarButtonItem(image: UIImage(named: "作者信息"), style: .plain, target: self, action: #selector(StarInformationViewController.user))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
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
        SwiftNotice.wait()
        //获取到 readme下载地址
        StarRequestHelper.readMe.requestReadMeFile(item.fullNamejson) { (readme) in
            guard let readme = readme else {self.load404();return}
            ReadMeDown.request(self.item.idjson, url: readme.download_url, html_url: readme.html_url, callback: { (res) in
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
    
     func loadreadMefromRealm(_ id:Int64){
        
        starReadMe = StarReadMeRealm.selectRreadMeByID(self.item.idjson)
        if starReadMe.readmeValue != nil {
            html = htmlheader(starReadMe.readmeValue!)
            webview.loadHTMLString(html, baseURL: nil)
            SwiftNotice.clear()
            
        }else {
            load404()
        }
    }
    
    
    
    /**
     404页面
     */
    fileprivate func load404(){
        let html404 = Bundle.main.url(forResource: "404", withExtension: "html")!
        html = try! NSString(contentsOf: html404, encoding: String.Encoding.utf8.rawValue) as String
        webview.loadHTMLString(html, baseURL: nil)
        SwiftNotice.clear()
        
    }
}

//MARK: SFSafariViewControllerDelegate
extension StarInformationViewController:SFSafariViewControllerDelegate{
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController){
        controller.dismiss(animated: true, completion: nil)
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
    
    func showSafari(_ url:String?){
        guard let url = url else { SwiftNotice.showNoticeWithText(NoticeType.error, text: "404", autoClear: true, autoClearTime: 2) ;return }
        guard url != " " else { SwiftNotice.showNoticeWithText(NoticeType.error, text: "404", autoClear: true, autoClearTime: 2) ;return }
        guard let _url = URL(string: url) else { SwiftNotice.showNoticeWithText(NoticeType.error, text: "404", autoClear: true, autoClearTime: 2) ;return }
        safari = SFSafariViewController(url: _url)
        present(safari, animated: true, completion: nil)
    }
    
}


