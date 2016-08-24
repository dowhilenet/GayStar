//
//  StarsTableViewCell.swift
//  GITStare
//
//  Created by xiaolei on 15/12/21.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class StarsTableViewCell: UITableViewCell {
    
     var imageview: UIImageView!
     var starImageView: UIImageView!
     var langImageView:UIImageView!


     var name: UILabel!
     var desText: UILabel!
     var starLabel: UILabel!
     var langLabel: UILabel!
     var autherName: UILabel!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .None
        configTableCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func initCell(star:StarModelJsonProtocol) {
//        imageview.kf_setImageWithURL(NSURL(string: star.avatarURLjson)!)
//        autherName.text = star.autherNamejson
//        desText.text = star.decriptionjson
//        name.text = star.namejson
//        langLabel.text = star.languagejson
//        starLabel.text = String(star.stargazersCountjson)
//    }
//    
    func initCell(_ star:StarBase) {
        imageview.kf_setImageWithURL(URL(string: star.avatarURLjson)!)
        autherName.text = star.autherNamejson
        desText.text = star.decriptionjson
        name.text = star.namejson
        langLabel.text = star.languagejson
        starLabel.text = String(star.stargazersCountjson)
    }
    
    func configTableCell(){
        self.selectionStyle = .none
        //头像
        imageview = UIImageView(image: UIImage(named: "Icon-60"))
//        imageview.layer.cornerRadius = 44.0 / 2
        self.addSubview(imageview)
        
        //name
        name = UILabel()
        name.numberOfLines = 0
        name.font = UIFont(name: "Candal", size: 16)
        
        self.addSubview(name)
        //auther name
        autherName = UILabel()
        autherName.numberOfLines = 0
        autherName.font = UIFont(name: "Orbitron", size: 12)
        
        self.addSubview(autherName)
        
       //starImageView
        starImageView = UIImageView(image: UIImage(named: "Rectangle 46"))
        self.addSubview(starImageView)
        
       //star Label
        starLabel = UILabel()
        starLabel.font = UIFont(name: "Orbitron", size: 12)
        self.addSubview(starLabel)
        
        //desText
        desText = UILabel()
        desText.numberOfLines = 0
        desText.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(desText)
        
        langImageView = UIImageView(image: UIImage(named: "code"))
        self.addSubview(langImageView)
        langLabel = UILabel()
        langLabel.font = UIFont(name: "Orbitron", size: 12)
        self.addSubview(langLabel)

       

        
        //头像布局
        imageview.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(8)
            make.height.width.equalTo(44.00)
        }
        
        //name 布局
        name.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(imageview.snp_trailing).offset(8)
            make.trailing.equalTo(-3)
            make.top.equalTo(imageview.snp_top)
            make.bottom.equalTo(imageview.snp_bottom).multipliedBy(0.7)
        }
        
        autherName.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(name.snp_leading)
            make.trailing.equalTo(name.snp_trailing)
            make.top.equalTo(name.snp_bottom)
            make.bottom.equalTo(imageview.snp_bottom)
        }
        //des text 布局
        desText.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(imageview.snp_bottom).offset(10)
            make.leading.equalTo(imageview.snp_leading)
            make.trailing.equalTo(-3)
        }
        // Star image view 布局
        starImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(desText.snp_bottom).offset(10)
            make.width.height.equalTo(20)
            make.leading.equalTo(imageview.snp_leading)
            make.bottom.equalTo(-8)
        }
        
        starLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(starImageView.snp_trailing).offset(12)
            make.top.equalTo(starImageView.snp_top)
            make.bottom.equalTo(starImageView.snp_bottom)
            make.height.equalTo(starImageView.snp_height)
        }
      
//        //lang image view  布局
        
        langImageView.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(20)
            make.leading.equalTo(starImageView.snp_trailing).offset(100)
            make.top.equalTo(starLabel.snp_top)
            
        }
        langLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(langImageView.snp_trailing).offset(12)
            make.top.equalTo(langImageView.snp_top)
            make.height.equalTo(langImageView.snp_height)
            make.bottom.equalTo(langImageView.snp_bottom)
            
        }
        
    }
    
}
