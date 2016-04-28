//
//  ReadMeDown.swift
//  GITStare
//
//  Created by xiaolei on 15/12/27.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ReadMeDownModel{
    var download_url: String = ""
    var html_url: String? = ""
    
    init(unboxer: NSData){
        let data = JSON(data:unboxer)
    download_url = data["download_url"].stringValue
    html_url = data["html_url"].stringValue
    }
}


class ReadMeDown{
    
    class func request(id:Int64,url:String,html_url:String?, callback:(Bool) -> Void){
        Alamofire.request(.GET, url)
        .validate()
        .responseString { (response) -> Void in
            
            if let readmeString = response.result.value{
                
                var options                = MarkdownOptions()
                options.autoHyperlink      = false
                options.autoNewlines       = true
                options.linkEmails         = false
                options.emptyElementSuffix = "/>"
                options.strictBoldItalic   = true
                options.encodeProblemUrlCharacters = true
                var markdown               = Markdown(options: options)
                let outputhtml             = markdown.transform(readmeString)
                var stareadme = StarReadMe()
                stareadme.id = id
                stareadme.readmeValue = outputhtml
                stareadme.readmeURL = outputhtml
                
                let value = StarReadMeSQLite.selectRreadMeByID(id).readmeValue
                var res = false
                if let _ = value {
                    
                    res = StarReadMeSQLite.updateReadMe(id, values: outputhtml)
                }else {
                    res = StarReadMeSQLite.insertReadMe(stareadme)
                }
                callback(res)
            }else{
                callback(false)
            }
        }
    }
    
 
}