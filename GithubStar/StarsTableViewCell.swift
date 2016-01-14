//
//  StarsTableViewCell.swift
//  GITStare
//
//  Created by xiaolei on 15/12/21.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import Haneke


class StarsTableViewCell: UITableViewCell {
    
     var imageview: UIImageView!
     var starImageView: UIImageView!
     var langImageView:UIImageView!


     var name: UILabel!
     var desText: UILabel!
     var starLabel: UILabel!
     var langLabel: UILabel!


    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        configTableCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCellItems(items:Results<(GithubStarsRealm)>,index:NSIndexPath){
        self.name.text = items[index.row].name
        self.desText.text = items[index.row].decription ?? "没有详细的描述"
        self.starLabel.text = items[index.row].stargazersCount.toString()
        self.langLabel.text = items[index.row].language ?? "NULL"
        self.imageview.hnk_setImageFromURL(NSURL(string: items[index.row].avatarURL)!)
    }
    
    func initCellByStarModel(res:[GithubStarsRealm],index:NSIndexPath){
        name.text = res[index.row].name
        desText.text = res[index.row].description ?? "没有详细的描述"
        starLabel.text = res[index.row].stargazersCount.toString()
        langLabel.text = res[index.row].language ?? "NULL"
        imageview.hnk_setImageFromURL(NSURL(string: res[index.row].avatarURL)!)
    }
    
    func configTableCell(){
        
        //头像
        imageview = UIImageView(image: UIImage(named: "Icon-60"))
        imageview.layer.cornerRadius = 44.0 / 2
        self.addSubview(imageview)
        
        //name
        name = UILabel()
        name.numberOfLines = 0
        name.font = UIFont.systemFontOfSize(20)
        
        self.addSubview(name)
        
       //starImageView
        starImageView = UIImageView(image: UIImage(named: "Icon-Small"))
        self.addSubview(starImageView)
       //star Label
        starLabel = UILabel()
        self.addSubview(starLabel)
        
        //desText
        desText = UILabel()
        desText.numberOfLines = 0
        self.addSubview(desText)
        
        langImageView = UIImageView(image: UIImage(named: "Icon-Small"))
        self.addSubview(langImageView)
        langLabel = UILabel()
        self.addSubview(langLabel)

       

        
        //头像布局
        imageview.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(2)
            make.height.width.equalTo(44.00)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        //name 布局
        name.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(imageview.snp_trailing).offset(2)
            make.trailing.equalTo(0)
            make.top.equalTo(imageview.snp_top)
//            marke.height.equalTo(self.imageview.snp_height)
            make.bottom.equalTo(self.imageview.snp_bottom)
        }
        //des text 布局
        desText.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(name.snp_bottom).offset(6)
            make.leading.trailing.equalTo(0)
        }
        // Star image view 布局
        starImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(desText.snp_bottom).offset(6)
            make.width.height.equalTo(20)
            make.leading.equalTo(0)
            make.bottom.equalTo(-2)
        }
        starLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(starImageView.snp_trailing).offset(2)
            make.top.equalTo(starImageView.snp_top)
            make.bottom.equalTo(starImageView.snp_bottom)
            make.height.equalTo(starImageView.snp_height)
        }
      
//        //lang image view  布局
        
        langImageView.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(20)
            make.leading.equalTo(starLabel.snp_trailing).offset(10)
            make.top.equalTo(starLabel.snp_top)
            
        }
        langLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(langImageView.snp_trailing).offset(2)
            make.top.equalTo(langImageView.snp_top)
            make.height.equalTo(langImageView.snp_height)
            make.bottom.equalTo(langImageView.snp_bottom)
            
        }
        
    }
    
}
