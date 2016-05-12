//
//  StarsCollectionViewCell.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/12.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

class StarsCollectionViewCell: UICollectionViewCell {

        /// Auther Name
    @IBOutlet weak var autherName: UILabel!
        /// Star Name
    @IBOutlet weak var starLabel:
    UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = randomColor(hue: .Green, luminosity: .Light)
    }
    
    func initCell(room:WilddogChatRoomModel) {
        autherName.text = room.autherName
        starLabel.text = room.roomName
    }

}
