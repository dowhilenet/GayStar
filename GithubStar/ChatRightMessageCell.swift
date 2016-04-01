//
//  ChatRightMessageCell.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/28.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit

class ChatRightMessageCell: UITableViewCell {
    
     var dateLabel: UILabel!
     var headImageView: UIButton!
     var nameLabel: UILabel!
     var contentButton: UIButton!
     var headImageURL: String!
     var contentLabel: UILabel!
    
     var imageHeightConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        dateLabel = UILabel()
        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        dateLabel.textColor = UIColor.grayColor()
        contentView.addSubview(dateLabel)
        dateLabel.snp_makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        headImageView = UIButton()
        contentView.addSubview(headImageView)
        headImageView.layer.borderWidth = 4
        headImageView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        headImageView.layer.cornerRadius = 25
        headImageView.clipsToBounds = true
        headImageView.setImage(UIImage(named: "headImage"), forState: .Normal)
        
        headImageView.snp_makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.trailing.equalTo(contentView).offset(-10)
            make.top.equalTo(dateLabel).offset(20)
        }
        
        contentLabel = UILabel()
        contentView.addSubview(contentLabel)
        contentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.whiteColor()
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(-90)
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.6)
            make.top.equalTo(headImageView).offset(10)
            make.bottom.equalTo(-20).priorityLow()
        }
        
        // 内容视图
        contentButton = UIButton()
        contentView.insertSubview(contentButton, belowSubview: contentLabel)
        contentButton.imageView?.contentMode = .ScaleAspectFill
        contentButton.setBackgroundImage(UIImage(named: "right_message_back"), forState: .Normal)
        contentButton.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(contentView).offset(-70)
            make.left.equalTo(contentLabel.snp_left).offset(-10)
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
    
    
    func configUIWithModel(model: ChatModel){
        dateLabel.text = model.time
        headImageURL = model.headImage
        headImageView.kf_setImageWithURL(NSURL(string: headImageURL)!, forState: .Normal)
        switch model.messageType {
        case ChatMessageType.Text:
            self.contentLabel.text = model.text
            break
        case .Image:
            self.contentLabel.text = ""
            self.contentButton.setImage(model.image, forState: .Normal)
            self.imageHeightConstraint.constant = UIScreen.mainScreen().bounds.size.width*0.6
            break
        case .Voice:
            break
        default:
            break
        }
    }

}
