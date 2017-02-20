//
//  TimeLineModel.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import SWXMLHash

struct TimeLineModel {
  var id: String?
  var published: String?
  var updated: String?
  var link: String?
  var title: String?
  var authorName: String?
  var authorURL: String?
  var thumbnail: String?
  
  init(formXML xml: XMLIndexer) {
    id = xml["id"].element?.text
    published = xml["published"].element?.text
    updated = xml["updated"].element?.text
    link = xml["link"].element?.attribute(by: "href")?.text
    title = xml["title"].element?.text
    authorName = xml["author"]["name"].element?.text
    authorURL = xml["author"]["uri"].element?.text
    thumbnail = xml["media:thumbnail"].element?.attribute(by: "url")?.text
  }
  
  static func getTimeLines(formData data: Data) -> [TimeLineModel] {
    var timeLines = [TimeLineModel]()
    let xml = SWXMLHash.parse(data)
    let entries = xml["feed"]["entry"].all
    entries.forEach { (xml) in
      let model = TimeLineModel(formXML: xml)
      timeLines.append(model)
    }
    return timeLines
  }
}
