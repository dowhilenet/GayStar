//
//  GroupTableViewCell.swift
//  GithubStar
//
//  Created by xiaolei on 16/1/25.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit

class GroupTableViewCell: UITableViewCell {
    
    var  button: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configTableCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
    
    func setButtonTitle(Title:String) {
        button.setTitle(Title, forState: .Normal)
    }
    
  
    
    func configTableCell(){
        
        self.selectionStyle = .None
        
        button = UIButton()
        self.addSubview(button)
        button.titleLabel?.font = UIFont.systemFontOfSize(18)
        button.enabled = false
        button.backgroundColor = UIColor.whiteColor()
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
    }
    
}
