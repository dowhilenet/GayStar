//
//  ReadMeDown.swift
//  GITStare
//
//  Created by xiaolei on 15/12/27.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
struct ReadMeDownModel{
    var download_url: String = ""
    var html_url: String? = ""
    
    init(unboxer: Data){
        let data = JSON(data:unboxer)
    download_url = data["download_url"].stringValue
    html_url = data["html_url"].stringValue
    }
}


class ReadMeDown{
    
    class func request(_ id:Int64,url:String,html_url:String?, callback:@escaping (Bool) -> Void){
//        Alamofire.request(.GET, url)
//        .validate()
//        .responseString { (response) -> Void in
//            
//            if let readmeString = response.result.value{
//                
//                var options                = MarkdownOptions()
//                options.autoHyperlink      = false
//                options.autoNewlines       = true
//                options.linkEmails         = false
//                options.emptyElementSuffix = "/>"
//                options.strictBoldItalic   = true
//                options.encodeProblemUrlCharacters = true
//                var markdown               = Markdown(options: options)
//                let outputhtml             = markdown.transform(readmeString)
//                //实例化一个read me 模型
//                let stareadme = StarReadMeRealm()
//                stareadme.id = id
//                stareadme.readmeValue = outputhtml
//                stareadme.readmeURL = html_url
//                //插入到数据库
//                let res = StarReadMeRealm.insertReadMe(stareadme)
//                callback(res)
//               
//            }else{
//                callback(false)
//            }
//        }
    }
    
 
}
