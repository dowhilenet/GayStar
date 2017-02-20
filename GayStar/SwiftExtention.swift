//
//  SwiftExtention.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import SwiftyJSON
import Moya

protocol SwiftyJSONAble {
  init?(fromJson json: JSON)
}

extension Data {

  /// 将data类型转换成 数据模型对象
  ///
  /// - parameter type: 继承ALSwiftyJSONAble协议的类型
  ///
  /// - returns: 返回一个可能是 nil 的数据对象模型
  func mapObject<T: SwiftyJSONAble>(type: T.Type) -> T? {
    
    let anyObject = try? JSONSerialization.jsonObject(with: self, options: [.allowFragments])
    
    guard let _anyObject = anyObject else { return nil }
    
    let jsonObject = JSON(_anyObject)
    
    return T(fromJson: jsonObject)
  }
  
  /// 将data类型转换成 数据模型对象数组
  ///
  /// - parameter type: 继承ALSwiftyJSONAble协议的类型
  ///
  /// - returns: 返回一个可能是空的数据对象模型数组
  func mapObjectsArray<T: SwiftyJSONAble>(type: T.Type) -> [T]?{
    
    let anyObject = try? JSONSerialization.jsonObject(with: self, options: [.allowFragments])
    
    guard let _anyObject = anyObject else { return nil }
    
    let mappedArray = JSON(_anyObject)
    
    let anyObjectsArray = mappedArray.arrayValue.flatMap{ T(fromJson: $0)}
    
    return anyObjectsArray
  }
}
