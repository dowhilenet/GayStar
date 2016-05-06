//
//  TagViewFloutLaout.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

class TagViewFloutLaout: UICollectionViewFlowLayout {
    func flowLaoutInit() {
        itemSize = CGSize(width: 50, height: 50)
        sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
