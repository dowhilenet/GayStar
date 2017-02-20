//
//  TimeLine.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import Moya


let TimeLineProvider = MoyaProvider(endpointClosure: { (target) -> Endpoint<TimeLine> in
  let url = target.baseURL.appendingPathComponent(target.path).absoluteString
  return Endpoint(
    url: url,
    sampleResponseClosure: { .networkResponse(200, target.sampleData) },
    method: target.method,
    parameters: target.parameters,
    parameterEncoding: target.parameterEncoding
  )
}, requestClosure: { (endpoint, closure) in
  if var urlRequest = endpoint.urlRequest {
    urlRequest.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
    urlRequest.addValue("token a7f6b892ea5afd4e83a59f203920f280bb5b469d", forHTTPHeaderField: "Authorization")
    closure(.success(urlRequest))
  } else {
    closure(.failure(MoyaError.requestMapping(endpoint.url)))
  }
}, plugins: [], trackInflights: false)

enum TimeLine {
  case currentUser(page: Int)
  case trendingToday
  case trendingWeek
  case trendingMonth
}

extension TimeLine: TargetType {
  var baseURL: URL { return URL(string: "https://github.com")! }
  
  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String {
    switch self {
      case .currentUser:
          return "/timeline"
    case .trendingToday, .trendingWeek, .trendingMonth:
          return "/trending"
    }
  }
  
  /// The HTTP method used in the request.
  var method: Moya.Method { return .get }
  
  /// The parameters to be incoded in the request.
  var parameters: [String: Any]? {
    switch self {
    case .currentUser(let page):
      return ["page":page]
    case .trendingWeek:
      return ["since":"weekly"]
    case .trendingMonth:
      return ["since":"monthly"]
    case .trendingToday:
      return nil
    }
  }
  
  /// The method used for parameter encoding.
  var parameterEncoding: ParameterEncoding { return URLEncoding.default }
  
  /// Provides stub data for use in testing.
  var sampleData: Data { return Data() }
  
  /// The type of HTTP task to be performed.
  var task: Task { return .request }
  
  /// Whether or not to perform Alamofire validation. Defaults to `false`.
  var validate: Bool { return false }
}
