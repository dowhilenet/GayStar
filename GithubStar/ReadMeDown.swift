//
//  ReadMeDown.swift
//  GITStare
//
//  Created by xiaolei on 15/12/27.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import Unbox



struct ReadMeDownModel:Unboxable{
    
    let download_url:String
    
    init(unboxer: Unboxer){
    download_url = unboxer.unbox("download_url")
    }
}


class ReadMeDown{
    
    class func request(id:Int,url:String, callback:(Bool) -> Void){
        Alamofire.request(.GET, url)
        .validate()
        .responseString { (response) -> Void in
            
            if let readmeString = response.result.value{
                var options                = MarkdownOptions()
                options.autoHyperlink      = false
                options.autoNewlines       = true
                options.linkEmails         = true
                options.emptyElementSuffix = ">"
                options.strictBoldItalic   = true
                var markdown               = Markdown(options: options)
                let outputhtml             = markdown.transform(readmeString)

                let starReadMeHtml         = GithubStarReadMe(value:["id":id,"htmlString":outputhtml])
                
                do{
                    try realm.write({ () -> Void in
                        realm.add(starReadMeHtml, update: true)
                        callback(true)
                    })
                }catch{
                        callback(false)
                }
            }else{
                callback(false)
            }
        }
    }
    
 
}