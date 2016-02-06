//
//  NTWaterfallViewCell.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit
import SnapKit
class NTWaterfallViewCell :UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
    var imageViewContent: UIImageView!
    var title: UILabel!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        imageViewContent = UIImageView()
        contentView.addSubview(imageViewContent)
        
        title = UILabel()
        title.numberOfLines = 0
        title.text = " 1232323232322"
        imageViewContent.addSubview(title)
        title.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(imageViewContent.snp_center)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewContent.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        imageViewContent.image = UIImage(named: "GitHub主页")
    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}