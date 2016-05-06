//
//  TrendingDevTableViewCell.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/5.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
//import RealmSwift

class TrendingDevTableViewCell: UITableViewCell {

    var phoneimage: UIImageView!
    var repodec: UILabel!
    var githubname: UILabel!
    var fullname: UILabel!
    var repoName: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initCell(dev:[TrendingDelevloperRealm],index:NSIndexPath) {
        phoneimage.kf_setImageWithURL(NSURL(string: dev[index.row].imageURL)!)
        githubname.text = dev[index.row].fullName
        fullname.text = dev[index.row].githubname
        repodec.text = dev[index.row].repoDec
        repoName.text = dev[index.row].repoName
    }
    
    
    func configCell() {
        
        self.selectionStyle = .None
        
        
        phoneimage = UIImageView(image: UIImage(named: "Icon-60"))
        self.addSubview(phoneimage)
        phoneimage.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading).offset(8)
            make.height.width.equalTo(44.00)
            make.top.equalTo(self.snp_top).offset(8)
        }
        
        githubname = UILabel()
        githubname.font = UIFont(name: "Candal", size: 16)
        self.addSubview(githubname)
        githubname.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(phoneimage.snp_trailing).offset(8)
            make.trailing.equalTo(self.snp_trailing).offset(-3)
            make.top.equalTo(phoneimage.snp_top)
            make.height.equalTo(phoneimage.snp_height).multipliedBy(0.7)
        }
        
        fullname = UILabel()
        fullname.font = UIFont(name: "Orbitron", size: 12)
        self.addSubview(fullname)
        fullname.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(githubname.snp_leading)
            make.top.equalTo(githubname.snp_bottom)
            make.trailing.equalTo(self.snp_trailing).offset(-3)
            make.bottom.equalTo(phoneimage.snp_bottom)
        }
        
        repoName = UILabel()
        repoName.font = UIFont(name: "Candal", size: 16)
        self.addSubview(repoName)
        repoName.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(phoneimage.snp_leading)
            make.top.equalTo(phoneimage.snp_bottom).offset(8)
            make.trailing.equalTo(self.snp_trailing).offset(-3)
        }
        
        repodec = UILabel()
        repodec.numberOfLines = 0
        repodec.font = UIFont.systemFontOfSize(14)
        self.addSubview(repodec)
        repodec.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(phoneimage.snp_leading)
            make.trailing.equalTo(self.snp_trailing).offset(-3)
            make.top.equalTo(repoName.snp_bottom).offset(5)
            make.bottom.equalTo(self.snp_bottom).offset(-8)
        }
    }
}
