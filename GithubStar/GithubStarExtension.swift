//
//  GithubStarExtension.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/4.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation
import Fuzi

import UIKit
/// Realm 的单例
class RealmData {
    static let share = RealmData()
    fileprivate init(){}
    ///初始化一个Realm时，仅需要在一个线程中之行一个这个初始化函数
    let realm = try! Realm()
}

extension Int{
    func toString() -> String{
        return String(self)
    }
}

extension String{
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toInt64() -> Int64? {
        return Int64(self)
    }
    
     mutating func addHTMLTag( _ html:String) -> String{
        self.append(html)
        return self
    }
}


let PullToRefreshTintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
let PullToRefreshFillColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.5)

func requestShowcasesData(){
    
    let showcasesRessURL = "https://github.com/showcases.atom"
    Alamofire.request(.GET, showcasesRessURL)
        .responseData { (res) -> Void in
            guard let data = res.data , let doc = try? XMLDocument(data: data) else { return }
            doc.definePrefix("atom", defaultNamespace: "http://www.w3.org/2005/Atom")
            guard let root = doc.root else { return }
            let entrys = root.children(tag: "entry", inNamespace: "atom")
            for entry in entrys {
                guard let title = entry.children(tag: "title", inNamespace: "atom").first , let url = entry.children(tag: "url", inNamespace: "atom").first else { return }
                print(title.stringValue,url.stringValue)
            }
    }
}


/**
 html 的内容
 
 - parameter boday: body neirong
 
 - returns: 完整的html
 */

func htmlheader(_ boday:String) -> String{
    var html = ""
    
    func loadCSS(_ fileName:String) -> String {
        let cssfilePatch = Bundle.main.path(forResource: fileName, ofType: "css")
        let cssString = try! NSString(contentsOfFile: cssfilePatch!, encoding:String.Encoding.utf8.rawValue) as String
        return "<style>" + cssString + "</style>"
    }
    
    func loadjsfile(_ fileName:String) -> String {
        let jsfilepatch = Bundle.main.path(forResource: fileName, ofType: "js")!
        let jsString = try! NSString(contentsOfFile: jsfilepatch, encoding: String.Encoding.utf8.rawValue) as String
        return "<script>" + jsString + "</script>"
    }
    
    func loadjs(_ string:String) -> String{
        
        return "<script>" + string + "</script>"
    }
    
    let css = loadCSS("cssstyle2")
    let markdownCss = loadCSS("cssstyle")
    let javascript = loadjsfile("jquery.min")
    let ajs = loadjs("$(function(){$('img').addClass(\"img-responsive\");$('a').click(function(){return false})})")
    html.addHTMLTag("<!DOCTYPE html>")
    html.addHTMLTag("<html>")
    html.addHTMLTag("<head>")
    html.addHTMLTag("<meta charset=\"UTF-8\">")
    html.addHTMLTag("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">")
    html.addHTMLTag(css)
    html.addHTMLTag(markdownCss)
    html.addHTMLTag("</head>")
    html.addHTMLTag("<body>")
    html.addHTMLTag("<div class=\"main-content\">")
    html.addHTMLTag("<div class=\"context-loader-container js-repo-nav-next\">")
    html.addHTMLTag("<div class=\"container new-discussion-timeline experiment-repo-nav\">")
    html.addHTMLTag("<div class=\"repository-content\">")
    html.addHTMLTag("<div class=\"readme boxed-group clearfix announce instapaper_body md\">")
    html.addHTMLTag("<article class=\"markdown-body entry-content\" itemprop=\"text\">")
    html.addHTMLTag(boday)
    html.addHTMLTag("</article>")
    html.addHTMLTag("</div></div></div></div></div>")
    html.addHTMLTag(javascript)
    html.addHTMLTag(ajs)
    html.addHTMLTag("</body></html>")
    
    return html
}


func updatestar() {
     let localcount = Defaults[.starredCount]
    //获取Starred 总数
    GetStarredCount.starredCount { (count) -> Void in
        if let count = count {
            if localcount < count {
                Defaults[.updateCount] = count
                Defaults.synchronize()
                SwiftNotice.showNoticeWithText(NoticeType.success, text: "Have Update, Please Pull", autoClear: true, autoClearTime: 2)
                
            }
        }
        
    }
}


extension UITableView{
    func configKongTable(_ title:String){
        let messageLbl = UILabel(frame:CGRect(x: 0, y: 0,width: self.bounds.size.width,height: self.bounds.size.height))
        messageLbl.backgroundColor = UIColor.clear
        messageLbl.text = title
        messageLbl.numberOfLines = 0
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont(name: "FrederickatheGreat", size: 18)
        messageLbl.sizeToFit()
        self.backgroundView = messageLbl
        self.separatorStyle = .none
    }
}

