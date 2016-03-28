//
//  ViewsCategory.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/28.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit


// find VC
extension UIView {
    
    func responderViewController() -> UIViewController {
        var responder: UIResponder! = nil
        for var next = self.superview; (next != nil); next = next!.superview {
            responder = next?.nextResponder()
            if (responder!.isKindOfClass(UIViewController)){
                return (responder as! UIViewController)
            }
        }
        return (responder as! UIViewController)
    }
}


extension UIScrollView {
    
    func scrollToBottom(animation animation:Bool) {
        let visibleBottomRect = CGRectMake(0, contentSize.height-bounds.size.height, 1, bounds.size.height)
        UIView.animateWithDuration(animation ? 0.2 : 0.01) { () -> Void in
            self.scrollRectToVisible(visibleBottomRect, animated: true)
        }
    }
}