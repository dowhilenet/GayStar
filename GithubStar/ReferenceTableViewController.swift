//
//  ReferenceTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 16/1/9.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import SwiftyUserDefaults

protocol ReferenceTableViewControllerDelegate{
    func didSelectedGroupDelegate(group:GithubGroupRealm)
}



class ReferenceTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{

    
    var tb: UITableView!
    var groupdelegate: ReferenceTableViewControllerDelegate?
    var names: Results<(GithubGroupRealm)>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Group"
        self.names = GithubGroupRealmAction.select()
        configTB()
        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


//MARK: Functions

extension ReferenceTableViewController{
    
    func configTB(){
        tb = UITableView()
        tb.separatorStyle = .None
        tb.registerClass(GroupTableViewCell.classForCoder(), forCellReuseIdentifier: "groupCell")
        tb.delegate = self
        tb.dataSource = self
        self.view.addSubview(tb)
        tb.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        let longtap = UILongPressGestureRecognizer()
        longtap.minimumPressDuration = 1.0
        longtap.addTarget(self, action: "longtap:")
        tb.addGestureRecognizer(longtap)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addgroups:")
    }
    
    
    func longtap(ges:UILongPressGestureRecognizer) {
        
        let tapPoint = ges.locationInView(self.tb)
        
        guard let  index = tb.indexPathForRowAtPoint(tapPoint) else {  return }
        
        let alert = UIAlertController(title: "\(names[index.row].name)", message: "Sure you want to remove it", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .Destructive, handler: { (action) -> Void in
            GithubGroupRealmAction.removeAgroup(self.names[index.row])
            self.tb.reloadData()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func addgroups(item:UIBarButtonItem){
        
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
}
//MARK: UITableViewDataSource
extension ReferenceTableViewController{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if names.count == 0{
            tb.configKongTable("There is no data  try add group")
            return 0
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as! GroupTableViewCell
        cell.setButtonTitle(names[indexPath.row].name)
        return cell
    }
}
//  MARK: UITableViewDelegate
extension ReferenceTableViewController{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let controller = GroupItemsTableViewController()
        controller.hidesBottomBarWhenPushed = true
        self.groupdelegate = controller
        self.groupdelegate?.didSelectedGroupDelegate(names[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 66
    }
}

