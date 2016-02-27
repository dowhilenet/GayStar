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
    var prompt = SwiftPromptsView()
    var deleteIndex = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Group"
        self.names = GithubGroupRealmAction.select()
        configTB()
        guard let _ = Defaults[.token] else{ GithubOAuth.GithubOAuth(self);return}
    }
    
    override func viewDidAppear(animated: Bool) {
        self.names = GithubGroupRealmAction.select()
        tb.reloadData()
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
        
        let left = UISwipeGestureRecognizer()
        left.direction = .Left
        
        let right = UISwipeGestureRecognizer()
        right.direction = .Right
        
        left.addTarget(self, action: "longtap:")
        right.addTarget(self, action: "longtap:")
        
        tb.addGestureRecognizer(right)
        tb.addGestureRecognizer(left)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addgroups:")
    }
    
    
    func longtap(ges:UISwipeGestureRecognizer) {
        
        let tapPoint = ges.locationInView(self.tb)

        guard let  index = tb.indexPathForRowAtPoint(tapPoint) else {  return }
        
        deletePrompts(self.view,title: "Delete", message: "You will remove \n \(names[index.row].name)")
        deleteIndex = index
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


extension ReferenceTableViewController:SwiftPromptsProtocol{
    // MARK: - Delegate functions for the prompt
    
    func clickedOnTheMainButton() {
        GithubGroupRealmAction.removeAgroup(names[deleteIndex.row])
        names = GithubGroupRealmAction.select()
        self.tb.reloadData()
        prompt.dismissPrompt()
    }
    
    
    func deletePrompts(view:UIView,title:String,message:String){
        //create
        prompt = SwiftPromptsView(frame: self.view.bounds)
        prompt.delegate = self
        
        //Set the properties of the prompt
        prompt.setPromptHeader(title)
        prompt.setPromptContentText(message)
        prompt.setPromptTopLineVisibility(true)
        prompt.setPromptBottomLineVisibility(false)
        prompt.setPromptBottomBarVisibility(true)
        prompt.setPromptDismissIconVisibility(true)
        prompt.setPromptOutlineVisibility(true)
        
        prompt.setPromptHeaderTxtColor(UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        prompt.setPromptOutlineColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setPromptDismissIconColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setPromptTopLineColor(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0))
        prompt.setPromptBackgroundColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.67))
        prompt.setPromptBottomBarColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setMainButtonColor(UIColor.whiteColor())
        prompt.setMainButtonText("OK")
        self.view.addSubview(prompt)
    }
}

