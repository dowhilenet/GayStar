//
//  ChooseLangueTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/11/29.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit

import SwiftyUserDefaults
protocol ChooseLangueTableViewControllerDelegate{
    func didSelectLan(lan:String)
}
class ChooseLangueTableViewController: UITableViewController {

    
    var langues = [String]()
    var delegate:ChooseLangueTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlange()
    }
    func initlange(){
    let patch = NSBundle.mainBundle().URLForResource("lang", withExtension: "plist", subdirectory: nil)
    let alllangues = NSArray(contentsOfURL: patch!)
    let langs = (alllangues?.firstObject)! as! NSArray
    langues = langs as! Array
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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

}
