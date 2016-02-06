//
//  TagViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/3.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit


class TagViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , PushStarProtocol{

    var tb: UITableView!
    var names: Results<(GithubGroupRealm)>!
    var item: GithubStarsRealm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Group"
        names = GithubGroupRealmAction.select()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add")
        
        tb = UITableView()
        self.view.addSubview(tb)
        tb.separatorStyle = .None
        tb.registerClass(GroupTableViewCell.classForCoder(), forCellReuseIdentifier: "tagCell")
        tb.delegate = self
        tb.dataSource = self
        tb.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        
    }
    
    func add(){
        let alert = UIAlertController(title: "Add Group", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (uitextfield) -> Void in
            uitextfield.placeholder = "Group Name"
        }
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            guard let name = alert.textFields?.first?.text else{ return }
    
            if let _ = self.names.indexOf(NSPredicate(format: "name = %@", name)){
                ProgressHUD.showError("Error")
                return
            }
            GithubGroupRealmAction.insert(name, callbock: { (res) -> Void in
                if res {
                    self.names = GithubGroupRealmAction.select()
                    self.tb.reloadData()
                }
            })
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if names.count == 0 {
            tb.configKongTable("There is no data  try add groups")
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath) as! GroupTableViewCell
        cell.setButtonTitle(names[indexPath.row].name)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 66
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name = names[indexPath.row].name
        GithubStarsRealmAction.updateStarOwnGroup(item, groupName: name) { (isSuccess) -> Void in
            if isSuccess {
                ProgressHUD.showSuccess("Success")
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                ProgressHUD.showSuccess("Error")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
    func didSelectedStar(item:GithubStarsRealm){
        self.item = item
    }
    
}
