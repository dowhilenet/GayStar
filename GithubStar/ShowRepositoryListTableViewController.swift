//
//  ShowRepositoryListTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/3.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import RealmSwift


class ShowRepositoryListTableViewController: UITableViewController, GroupItemsTableViewControllerDelegate{

    
    var stars: Results<(GithubStarsRealm)>!
    var starsdic = [String:[GithubStarsRealm]]()
    var starsSectionTitles = [String]()
    let starsIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var groupName: GithubGroupRealm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositories"
        self.tableView.registerClass(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: "starlist")
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        stars = GithubStarsRealmAction.selectStarsSortByName()
        createStarsDic()
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return starsSectionTitles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let starkey = starsSectionTitles[section]
        if let stars = starsdic[starkey] {
            return stars.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("starlist", forIndexPath: indexPath) as! StarsTableViewCell
        
        let starkey = starsSectionTitles[indexPath.section]
        if let stars = starsdic[starkey] {
            cell.initCellByStarModel(stars, index: indexPath)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return starsSectionTitles[section]
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return starsIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int{
        guard let  index = starsSectionTitles.indexOf(title) else {
            return -1
        }
        return index
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont(name: "FrederickatheGreat", size: 18.0)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let starkey = starsSectionTitles[indexPath.section]
        let stars = starsdic[starkey]
        let selectstar = stars![indexPath.row]
        GithubStarsRealmAction.updateStarOwnGroup(selectstar, groupName: groupName.name) { (success) -> Void in
            if success {
                ProgressHUD.showSuccess("Success")
                
            }else{
                ProgressHUD.showError("Error")
                
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func createStarsDic() {
        stars.forEach { (star) -> () in
            let starKey = star.name.substringToIndex(star.name.startIndex.advancedBy(1)).uppercaseString
            if var starValue = starsdic[starKey]{
                starValue.append(star)
                starsdic[starKey] = starValue
            }else{
                starsdic[starKey] = [star]
            }
        }
        starsSectionTitles = [String](starsdic.keys)
        starsSectionTitles.sortInPlace({$0 < $1})
    }
    

    
    func groupName(name:GithubGroupRealm){
        groupName = name
    }
}
