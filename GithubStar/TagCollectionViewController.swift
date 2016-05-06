//
//  TagCollectionViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TagCell"

class TagCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    var item: StarRealm!
    var names = [StarGroupRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.registerClass(TagCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.title = "Group"
        names = StarGroupRealm.select()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.add))
    }

    // MARK: UICollectionViewDataSource

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
        let name = names[indexPath.row].name
        let star = StarRealm.selectStarByID(item.idjson)
        guard let Star = star else { return }
        Star.groupsName = name
        StarRealm.intsertStar(Star)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension TagCollectionViewController {
    func add(){
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
