//
//  StarRequestHelper.swift
//  GithubStar
//
//  Created by xiaolei on 16/4/26.
//  Copyright © 2016年 xiaolei. All rights reserved.
//



enum StarRequestHelper {
    
    case stared
    case readMe
    
    /**
     请求Stared 的项目
     
     - parameter page:       页数
     - parameter completion: 回调
     */
    func requestStared(_ page: String, completion: @escaping (_ stars:[StarRealm]) -> Void) {
    switch self {
    case .stared:
        Alamofire.request(GithubAPI.star(page: page))
        .validate()
        .responseData(completionHandler: { (res) in
            if res.result.isFailure {
                completion(stars: [])
            }
            guard let data = res.data else {completion(stars: []); return}
            let stars = StarRealm.initStarArray(data)
            StarRealm.insertStars(stars)
            completion(stars: stars)
        })
    default:
        completion([])
    }
   }
    
    /**
     请求 readme 文件
     
     - parameter name:       项目名称
     - parameter completion: 回调函数
     */
    func requestReadMeFile(_ name:String, completion: @escaping (_ readme: ReadMeDownModel?) -> Void) {
        Alamofire.request(GithubAPI.readme(name: name))
        .validate()
        .responseData { (res) in
            guard let data = res.data else { completion(readme: nil); return}
            let model = ReadMeDownModel(unboxer: data)
            completion(readme: model)
        }
    }
}

