//
//  ReadMeDown.swift
//  GITStare
//
//  Created by xiaolei on 15/12/27.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import Alamofire
//import RealmSwift
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
    
    class func request(id:Int,url:String,html_url:String?, callback:(Bool) -> Void){
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

//                let starReadMeHtml         = GithubStarReadMe(value:
//                    ["id" : id ,
//                    "htmlString" : outputhtml ,
//                    ])
//                starReadMeHtml.html_url = html_url
                
//                do{
//                    try realm.write({ () -> Void in
//                        realm.add(starReadMeHtml, update: true)
//                        callback(true)
//                    })
//                }catch{
//                        callback(false)
//                }
            }else{
                callback(false)
            }
        }
    }
    
 
}