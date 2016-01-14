//
//  MyNSUserDefaults.swift
//  GITStare
//
//  Created by xiaolei on 15/11/24.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
extension DefaultsKeys{
    static let token                 = DefaultsKey<String?>("token")
    static let HaveDownAllPagesStars = DefaultsKey<Bool>("isAll")
    static let number                = DefaultsKey<Int>("number")
    static let starredCount          = DefaultsKey<Int>("starredCount")
}


