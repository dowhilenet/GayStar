//
//  GithubStarExtension.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/4.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation
import Fuzi
import Alamofire


extension Int{
    func toString() -> String{
        return String(self)
    }
}

extension String{
    func toInt() -> Int?{
        return Int(self)
    }
}


let PullToRefreshTintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
let PullToRefreshFillColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.5)

func requestShowcasesData(){
    
    let showcasesRessURL = "https://github.com/showcases.atom"
    Alamofire.request(.GET, showcasesRessURL)
        .responseData { (res) -> Void in
            guard let data = res.data , doc = try? XMLDocument(data: data) else { return }
            doc.definePrefix("atom", defaultNamespace: "http://www.w3.org/2005/Atom")
            guard let root = doc.root else { return }
            let entrys = root.children(tag: "entry", inNamespace: "atom")
            for entry in entrys {
                guard let title = entry.children(tag: "title", inNamespace: "atom").first , url = entry.children(tag: "url", inNamespace: "atom").first else { return }
                print(title.stringValue,url.stringValue)
            }
    }
}


/**
 html 的内容
 
 - parameter boday: body neirong
 
 - returns: 完整的html
 */

func htmlheader(boday:String) -> String{
    
    var  css:String{
        let star = "<style>"
        
        let cssfilePatch = NSBundle.mainBundle().pathForResource("bootstrap.min", ofType: "css")!
        let cssString = try! NSString(contentsOfFile: cssfilePatch, encoding:NSUTF8StringEncoding) as String
        let end = "</style>"
        let mycss = "<style>" + "  .container-fluid{margin:8px;}" + "</style>"
        
        return star + cssString + end + mycss
    }
    
    var markdwoncss:String{
        let star = "<style>"
        
        let cssfilePatch = NSBundle.mainBundle().pathForResource("markdown", ofType: "css")!
        let cssString = try! NSString(contentsOfFile: cssfilePatch, encoding:NSUTF8StringEncoding) as String
        let end = "</style>"
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