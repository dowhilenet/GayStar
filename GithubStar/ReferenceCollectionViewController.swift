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

class ReferenceCollectionViewController: UICollectionViewController{

    var names = [StarGroupRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        title = "Group"
        collectionView!.registerClass(TagCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.addgroups(_:)))
        
        names = StarGroupRealm.select()
        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        names = StarGroupRealm.select()
        collectionView?.reloadData()
    }

    // MARK: UICollectionVsiewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return names.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TagCollectionViewCell
        cell.titleLabel.text = names[indexPath.row].name
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let controller = GroupItemsTableViewController()
        controller.hidesBottomBarWhenPushed = true
        controller.name = names[indexPath.row].name
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ReferenceCollectionViewController {
    func addgroups(item:UIBarButtonItem){
        let alert = UIAlertController(title: "Add Group", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (uitextfield) -> Void in
            uitextfield.placeholder = "Group Name"
        }
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
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
        presentViewController(alert, animated: true, completion: nil)
    }
}

