//
//  ShowcasesRequest.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/5.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation
import Fuzi
import Alamofire

class ShowcasesRequest {
    fileprivate static let baseurl = "https://github.com"
    
    class func requestShowcases() {
//        var dataa = [ShowcasesRealm]()
        let url = baseurl + "/showcases"
        Alamofire.request(.GET, url).responseData { (res) -> Void in
            guard let data = res.data , let cards = try? HTMLDocument(data: data).css(".collection-card") else {  return }
            cards.forEach({ (card) -> () in
                guard let title = card.css(".collection-card-title").first?.stringValue  ,  let carImage = card.css(".collection-card-image").first else { return }
                
                guard var carURL = carImage["href"] , var imageURL = carImage["style"] else { return }
                carURL = baseurl + carURL
                let range = imageURL.startIndex ... imageURL.startIndex.advancedBy(21)
                imageURL.removeRange(range)
                imageURL.removeAtIndex(imageURL.endIndex.predecessor())
                imageURL.removeAtIndex(imageURL.endIndex.predecessor())
                
//                let one = ShowcasesRealm()
//                one.title = title
//                one.url = carURL
//                one.imageurl = imageURL
//                dataa.append(one)
                
            })
//            guard dataa.count > 0 else { return }
//            ShowcasesRealmAction.insert(dataa)
        }
    }
    
}
