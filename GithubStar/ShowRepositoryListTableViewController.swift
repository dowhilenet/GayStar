//
//  ShowRepositoryListTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/3.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

class ShowRepositoryListTableViewController: UITableViewController{

    
    var stars = [StarRealm]()
    var starsdic = [String:[StarRealm]]()
    var starsSectionTitles = [String]()
    let starsIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var groupName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositories"
        self.tableView.register(StarsTableViewCell.classForCoder(), forCellReuseIdentifier: "starlist")
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        stars = StarRealm.selectStarsByGroups()
        createStarsDic()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return starsSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let starkey = starsSectionTitles[section]
        if let stars = starsdic[starkey] {
            return stars.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "starlist", for: indexPath) as! StarsTableViewCell
        
        let starkey = starsSectionTitles[(indexPath as NSIndexPath).section]
        if let stars = starsdic[starkey] {
            let star = stars[(indexPath as NSIndexPath).row]
            cell.initCell(star)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return starsSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return starsIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int{
        guard let  index = starsSectionTitles.index(of: title) else {
            return -1
        }
        return index
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let headerView = view as! UITableViewHeaderFooterView
//        headerView.textLabel?.font = UIFont(name: "FrederickatheGreat", size: 18.0)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let starkey = starsSectionTitles[(indexPath as NSIndexPath).section]
        let stars = starsdic[starkey]
        let selectstar = stars![(indexPath as NSIndexPath).row]
        StarRealm.updateGroup(selectstar, groupName: groupName)
        navigationController?.popViewController(animated: true)
    }
    
    
    func createStarsDic() {
        stars.forEach { (star) -> () in
            let starKey = star.namejson.substringToIndex(star.namejson.index(star.namejson.startIndex, offsetBy: 1)).uppercased()
            if var starValue = starsdic[starKey]{
                starValue.append(star)
                starsdic[starKey] = starValue
            }else{
                starsdic[starKey] = [star]
            }
        }
        starsSectionTitles = [String](starsdic.keys)
        starsSectionTitles.sort(by: {$0 < $1})
    }
    
}
