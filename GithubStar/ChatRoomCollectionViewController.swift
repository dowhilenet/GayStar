//
//  StarsCollectionViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/12.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Wilddog

private let reuseIdentifier = "StarsCollectionCell"

class ChatRoomCollectionViewController: UIViewController {

    var rooms = [WilddogChatRoomModel]()
    var collectionView: UICollectionView!
    var roomRef: Wilddog!
    var room: WilddogChatRoomModel! {
        didSet{
          roomRef = WilddogManager.ref.childByAppendingPath(room.roomId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpCollectionView()
        setUpNavigationView()
        setUpWilddog()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let stars = StarRealm.selectStars()
        stars.forEach { (star) in
            let room = WilddogChatRoomModel(star: star)
            rooms.append(room)
        }
        collectionView.reloadData()
    }



}

extension ChatRoomCollectionViewController {
    
    func setUpWilddog() {
        //用户登陆
        WilddogManager.wilddogLogin()
        //检测是否有用户信息
        let user = UserRealm.selectUser()
        
        guard let _ = user else { GithubOAuth.GithubOAuth(self); return }

    }
    
    func setUpNavigationView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
    }
    
    func setUpView() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func setUpCollectionView() {
        let layout = HanabiCollectionViewLayout()
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "StarsCollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}



 // MARK: UICollectionViewDelegate
extension ChatRoomCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        room = rooms[indexPath.row]
        let chatController = ChatViewController()
        chatController.room = room
        chatController.hidesBottomBarWhenPushed = true
        chatController.title = room.roomName
        navigationController?.pushViewController(chatController, animated: true)
    }
}

 // MARK: UICollectionViewDataSource
extension ChatRoomCollectionViewController: UICollectionViewDataSource {
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return rooms.count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StarsCollectionViewCell
        cell.initCell(rooms[indexPath.row])
        return cell
    }
}
