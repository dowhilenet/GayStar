//
//  StarsCollectionViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/12.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit


private let reuseIdentifier = "StarsCollectionCell"

class ChatRoomCollectionViewController: UIViewController {

    var rooms = [WilddogChatRoomModel]()
    var collectionView: UICollectionView!
    var roomRef: Wilddog!
    var room: WilddogChatRoomModel! {
        didSet{
          roomRef = WilddogManager.ref?.child(byAppendingPath: room.roomId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpCollectionView()
        setUpNavigationView()
        setUpWilddog()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func setUpView() {
        view.backgroundColor = UIColor.white
    }
    
    func setUpCollectionView() {
        let layout = HanabiCollectionViewLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "StarsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}



 // MARK: UICollectionViewDelegate
extension ChatRoomCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        room = rooms[(indexPath as NSIndexPath).row]
        let chatController = ChatViewController()
        chatController.room = room
        chatController.hidesBottomBarWhenPushed = true
        chatController.title = room.roomName
        navigationController?.pushViewController(chatController, animated: true)
    }
}

 // MARK: UICollectionViewDataSource
extension ChatRoomCollectionViewController: UICollectionViewDataSource {
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return rooms.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StarsCollectionViewCell
        cell.initCell(rooms[(indexPath as NSIndexPath).row])
        return cell
    }
}
