//
//  TrendingModel.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/20.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import Foundation
import Kanna
import SwifterSwift
struct TrendingModel {
  var repoName: String
  var repoInfor: String
  var stargazers: String
  var builtBy: [String]
  var repoLanguage = ""
  var respURL: String
  
  init(fromXML xml: XMLElement) {
    
    let divs = xml.xpath("./div")
    repoName = divs[0].text ?? ""
    repoName = repoName.withoutSpacesAndNewLines
    let index = repoName.firstIndex(of: "/") ?? 0
    repoName = repoName.slicing(at: index + 1) ?? ""
    let aa = xml.xpath("./div/h3/a")
    respURL = "https://github.com" + (aa.first?["href"] ?? "/")
    respURL = respURL.withoutSpacesAndNewLines
    repoInfor = divs[2].text ?? ""
    repoInfor = repoInfor.withoutSpacesAndNewLines
    let a = divs[3].xpath("./a")
    stargazers = a[0].content ?? ""
    stargazers = stargazers.withoutSpacesAndNewLines
    let span = divs[3].xpath("./span")
    if span.count != 1 {
      
      repoLanguage = span[1].content ?? ""
      repoLanguage = repoLanguage.withoutSpacesAndNewLines
    }
    let builtBya = a[2].xpath("./img")
    builtBy = []
    builtBya.forEach { (img) in
      let imgurl = img["src"]
      self.builtBy.append(imgurl!)
    }
  }
  
  static func getTrendingArray(fromData data: Data) -> [TrendingModel] {
    let html = HTML(html: data, encoding: .utf8)
    guard let li = html?.xpath("/html/body/div[4]/div[2]/div[2]/div[1]/div[2]/ol/li") else {
      return []
    }
    var trending = [TrendingModel]()

    li.forEach { (xml) in
      let trend = TrendingModel(fromXML: xml)
      trending.append(trend)
    }
    return trending
  }
}
