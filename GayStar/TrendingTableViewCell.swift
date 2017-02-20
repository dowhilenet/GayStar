//
//  TrendingTableViewCell.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/20.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
class TrendingTableViewCell: UITableViewCell {

  private var trend: TrendingModel! {
    didSet{
      nameLabel.text = trend.repoName
      inforLabel.text = trend.repoInfor
      starNumberLabel.text = trend.stargazers
      langLabel.text = trend.repoLanguage
    }
  }
  
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  
  lazy var inforLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  lazy var starNumberLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var langLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { (make) in
      make.leading.top.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
    contentView.addSubview(inforLabel)
    inforLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(nameLabel.snp.leading)
      make.top.equalTo(nameLabel.snp.bottom).offset(5)
      make.trailing.equalToSuperview().offset(-10)
    }
    contentView.addSubview(starNumberLabel)
    starNumberLabel.snp.makeConstraints { (make) in
      make.top.equalTo(inforLabel.snp.bottom).offset(5)
      make.leading.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    contentView.addSubview(langLabel)
    langLabel.snp.makeConstraints { (make) in
      make.top.equalTo(starNumberLabel.snp.top)
      make.bottom.equalTo(starNumberLabel.snp.bottom)
      make.trailing.equalToSuperview()
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setUpCell(trending: TrendingModel) {
    self.trend = trending
  }
}
