//
//  ChatLeftMessageCell.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/28.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ChatLeftMessageCell: UITableViewCell {
    //时间
    var dateLabel: UILabel!
    //头像
    var headImageView: UIButton!
    //名字
    var nameLabel: UILabel!
    //消息内容
    var contentButton: UIButton!
    var contentLabel: UILabel!
    var imageHeightConstraint: NSLayoutConstraint!
    //头像地址
    var headImageUrl = ""
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        //日期
        dateLabel = UILabel()
        contentView.addSubview(dateLabel)
        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        dateLabel.textColor = UIColor.grayColor()
        dateLabel.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(4)
            make.centerX.equalTo(contentView)
        }
        
        //头像
        headImageView = UIButton()
        contentView.addSubview(headImageView)
        headImageView.layer.borderWidth = 4
        headImageView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        headImageView.layer.cornerRadius = 25
        headImageView.clipsToBounds = true
        headImageView.kf_setImageWithURL(NSURL(string: headImageUrl)!, forState: .Normal)
        
        headImageView.snp_makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.leading.equalTo(10)
            make.top.equalTo(dateLabel).offset(20)
        }
        //内容 frame 辅助
        contentLabel = UILabel()
        contentView.addSubview(contentLabel)
        contentLabel.font = UIFont.systemFontOfSize(30)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.grayColor()
        contentLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(90)
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.6)
            make.top.equalTo(headImageView).offset(10)
            make.bottom.equalTo(-20).priorityLow()
        }
        
        // 内容视图
        contentButton = UIButton()
        // 插入到 contentLabel 的下边
        contentView.insertSubview(contentButton, belowSubview: contentLabel)
        contentButton.clipsToBounds = true
        contentButton.setBackgroundImage(UIImage(named: "left_message_back"), forState: .Normal)
        contentButton.snp_makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(70)
            make.trailing.equalTo(contentLabel.snp_trailing).offset(10)
            make.top.equalTo(headImageView)
            make.bottom.equalTo(contentLabel.snp_bottom).offset(10)
        }
        
        // temporary method
        
        imageHeightConstraint = NSLayoutConstraint(
            item: contentButton,
            attribute: .Height,
            relatedBy: .LessThanOrEqual,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 1000)
        imageHeightConstraint.priority = UILayoutPriorityRequired
        contentButton.addConstraint(imageHeightConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configUIWithModel(model: ChatModel) {
        dateLabel.text = model.time
        headImageUrl = model.headImage
        switch model.messageType {
        case ChatMessageType.Text:
            contentLabel.text = model.text
        case .Image:
            contentLabel.text = ""
            contentButton.setBackgroundImage(model.image, forState: .Normal)
            imageHeightConstraint.constant = UIScreen.mainScreen().bounds.size.width * 0.6
        case .Voice:
            break
        default:
            break
        }
    }

}
