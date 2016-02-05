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