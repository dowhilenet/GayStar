//
//  TimeLineTableViewCell.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit
import Kingfisher
class TimeLineTableViewCell: UITableViewCell {

  private var timeLineModel: TimeLineModel! {
    didSet{
      thumbnail.kf.setImage(with: URL(string:timeLineModel.thumbnail!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
      nameLabel.text = timeLineModel.authorName
      titleLabel.text = timeLineModel.title
    }
  }
  
  lazy var thumbnail: UIImageView = {
    let image = UIImageView()
    return image
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15)
    return label
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byTruncatingTail
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(thumbnail)
    thumbnail.snp.makeConstraints { (make) in
      make.height.width.equalTo(30)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(10)
    }
    
    contentView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(thumbnail.snp.trailing).offset(10)
      make.top.equalTo(thumbnail.snp.top)
    }
    
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(nameLabel.snp.leading)
      make.bottom.equalTo(thumbnail.snp.bottom)
      make.trailing.equalToSuperview().offset(-10)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  func setUpCell(timeLineModel: TimeLineModel) {
    self.timeLineModel = timeLineModel
  }
}
