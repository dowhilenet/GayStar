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
    var rootviewcontroller: PageMenuViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        initlange()
        self.title = "All Languages"
    }
    
    func initlange(){
    let patch = NSBundle.mainBundle().URLForResource("lang", withExtension: "plist", subdirectory: nil)
    let alllangues = NSArray(contentsOfURL: patch!)
    let langs = (alllangues?.firstObject)! as! NSArray
    langues = langs as! Array
    langues.forEach { (lang) -> () in
        let a = String(lang[lang.startIndex]).uppercaseString
        if let _ = sectionLangues[a] {
            sectionLangues[a]?.append(lang)
        }else {
            sectionLangues[a] = [lang]
        }
        }
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
        let key = starsIndexTitles[section]
        if let lang = sectionLangues[key] {
            return lang.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LangueCell", forIndexPath: indexPath)
        let key = starsIndexTitles[indexPath.section]
        cell.textLabel?.text = sectionLangues[key]![indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = starsIndexTitles[indexPath.section]
        let lang = sectionLangues[key]![indexPath.row]
        self.delegate = rootviewcontroller
        self.delegate?.didSelectLan(lang)
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return starsIndexTitles[section]
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return starsIndexTitles
    }

    
}
