//
//  NTNavigationController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/5.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

class NTNavigationController: UINavigationController {

    override func popViewControllerAnimated(animated: Bool) -> UIViewController
    {
        //viewWillAppearWithPageIndex
        let childrenCount = self.viewControllers.count
        let toViewController = self.viewControllers[childrenCount-2] as! NTWaterFallViewControllerProtocol
        let toView = toViewController.transitionCollectionView()
        let popedViewController = self.viewControllers[childrenCount-1] as! UICollectionViewController
        let popView  = popedViewController.collectionView!;
        let indexPath = popView.fromPageIndexPath()
        toViewController.viewWillAppearWithPageIndex(indexPath.row)
        toView.setToIndexPath(indexPath)
        return super.popViewControllerAnimated(animated)!
    }

}
