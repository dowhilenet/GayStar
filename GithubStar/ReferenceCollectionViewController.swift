//
//  ReferenceCollectionViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SwiftyUserDefaults


private let reuseIdentifier = "ReferenceCell"

class ReferenceCollectionViewController: UIViewController {

    var names = [StarGroupRealm]()
    var collectionView: UICollectionView!
    
    var cellSizes: [CGSize]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpCollectionView()
        setUpNavgation()

        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        names = StarGroupRealm.select()
        collectionView?.reloadData()
    }




}

// MARK: Extention
extension ReferenceCollectionViewController {
    func setUpView() {
        title = "Group"
        names = StarGroupRealm.select()
    }
    
    func setUpCollectionView() {
        
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumColumnSpacing = 8
        layout.minimumInteritemSpacing = 8
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView!.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func setUpNavgation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addgroups(_:)))
    }
}

// MARK: UICollectionVsiewDataSource
extension ReferenceCollectionViewController: UICollectionViewDataSource {

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TagCollectionViewCell
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.text = names[(indexPath as NSIndexPath).row].name
        cell.titleLabel.backgroundColor = UIColor.blue
        return cell
    }
}

//MARK: CollectionViewWaterfallLayoutDelegate
extension ReferenceCollectionViewController: CollectionViewWaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let name = names[(indexPath as NSIndexPath).item]
        let rect = NSString(string:name.name).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)], context: nil)
        print(rect.height,rect.width)
        return rect.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = GroupItemsTableViewController()
        controller.hidesBottomBarWhenPushed = true
        controller.name = names[(indexPath as NSIndexPath).row].name
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


extension ReferenceCollectionViewController {

    
    func addgroups(_ item:UIBarButtonItem){
        let alert = UIAlertController(title: "Add Group", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (uitextfield) -> Void in
            uitextfield.placeholder = "Group Name"
        }
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            guard let name = alert.textFields?.first?.text else{ return }
            let newChars = name.characters.filter({ (char) -> Bool in
                return char != " "
            })
            guard newChars.count > 0 else { return }
            let res = StarGroupRealm.insert(StarGroupRealm(name: name))
            if res {
                self.names = StarGroupRealm.select()
                self.collectionView!.reloadData()
            }else {
                print("inset groups error")
            }
            
        }))
        present(alert, animated: true, completion: nil)
    }
}

