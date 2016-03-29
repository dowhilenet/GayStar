//
//  ChatTableViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/28.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit


class ChatTableViewController: UIViewController {

    
    private let leftCellId = "ChatLeftMessageCell"
    private let rightCellId = "ChatRightMessageCell"
    
    var chatTableView: UITableView!
    var inputBackView: InputView!
    var dataArray: [ChatModel]!
    var inputViewConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = [ChatModel]()
        
        inputBackView = InputView()
        view.addSubview(inputBackView)
        
        inputViewConstraint = NSLayoutConstraint(
            item: inputBackView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0
        )
        
        inputBackView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
        }
        
        view.addConstraint(inputViewConstraint!)
        
        inputBackView.sendMessage(imageBlock: { (image, textView) in
            self.dataArray.append(ChatModel.creatMessageFromMeByImage(image))
            self.chatTableView.reloadData()
            self.chatTableView.scrollToBottom(animation: true)
            }, textBlock: { (text, textView) in
                self.dataArray.append(ChatModel.creatMessageFromMeByText(text))
                self.chatTableView.reloadData()
                self.chatTableView.scrollToBottom(animation: true)
            }) { (voice, textView) in
                
        }
        
        chatTableView = UITableView(frame: CGRectZero, style: .Plain)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.separatorStyle = .None
        chatTableView.keyboardDismissMode = .Interactive
        chatTableView.estimatedRowHeight = 60
        view.addSubview(chatTableView)
        chatTableView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(self.view).offset(64)
            make.bottom.equalTo(inputBackView.snp_top)
        }
        
        chatTableView.registerClass(ChatLeftMessageCell.classForCoder(), forCellReuseIdentifier: leftCellId)
        chatTableView.registerClass(ChatRightMessageCell.classForCoder(), forCellReuseIdentifier: rightCellId)
        chatTableView.estimatedRowHeight = 100
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatTableViewController.keyboardFrameChanged(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardFrameChanged(notification: NSNotification) {
        
        let dict = NSDictionary(dictionary: notification.userInfo!)
        let keyboardValue = dict.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let bottomDistance = mainScreenSize().height - keyboardValue.CGRectValue().origin.y
        let duration = Double(dict.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        
        UIView.animateWithDuration(duration, animations: {
            self.inputViewConstraint!.constant = -bottomDistance
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                self.chatTableView.scrollToBottom(animation: true)
        })
    }
    
    private func mainScreenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }

}

// MARK: - Table view data source

extension ChatTableViewController: UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.row]
        if model.from == .Me {
            let cell = tableView.dequeueReusableCellWithIdentifier(rightCellId,forIndexPath: indexPath) as! ChatRightMessageCell
            cell.configUIWithModel(model)
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(leftCellId, forIndexPath: indexPath) as! ChatLeftMessageCell
            cell.configUIWithModel(model)
            return cell
        }
        
    }
}


extension ChatTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
}
