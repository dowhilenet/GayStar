//
//  ChooseLangueTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/11/29.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit

protocol ChooseLangueTableViewControllerDelegate{
    func didSelectLan(lan:String)
}


class LangCell: UITableViewCell{
    
}


class ChooseLangueTableViewController: UITableViewController {

    
    var langues = [String]()
    var delegate:ChooseLangueTableViewControllerDelegate?
    let starsIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var sectionLangues = [String:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlange()
    }
    
    func initlange(){
    let patch = NSBundle.mainBundle().URLForResource("lang", withExtension: "plist", subdirectory: nil)
    let alllangues = NSArray(contentsOfURL: patch!)
    let langs = (alllangues?.firstObject)! as! NSArray
    langues = langs as! Array
    self.tableView.registerClass(LangCell.self, forCellReuseIdentifier: "LangueCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return starsIndexTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return langues.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LangueCell", forIndexPath: indexPath)

        cell.textLabel?.text = langues[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate?.didSelectLan(self.langues[indexPath.row])
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return starsIndexTitles[section]
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return starsIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int{
      
        return index
    }

    
}
