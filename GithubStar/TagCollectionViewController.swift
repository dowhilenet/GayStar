//
//  TagCollectionViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TagCell"

class TagCollectionViewController: UICollectionViewController{

    var item: StarRealm!
    var names = [StarGroupRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        self.title = "Group"
        names = StarGroupRealm.select()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return names.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TagCollectionViewCell
        cell.titleLabel.text = names[(indexPath as NSIndexPath).row].name
        return cell
    }

    // MARK: UICollectionViewDelegate
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = names[(indexPath as NSIndexPath).row].name
        let star = StarRealm.selectStarByID(item.idjson)
        guard let Star = star else { return }
        StarRealm.updateGroup(Star, groupName: name)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
 
}

extension TagCollectionViewController {
    func add(){
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
