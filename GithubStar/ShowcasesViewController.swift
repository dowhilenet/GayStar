//
//  ShowcasesViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/5.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Fuzi
import Alamofire

let waterfallViewCellIdentify = "waterfallViewCellIdentify"

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        let fromVCConfromA = (fromVC as? NTTransitionProtocol)
        let fromVCConfromB = (fromVC as? NTWaterFallViewControllerProtocol)
        let fromVCConfromC = (fromVC as? NTHorizontalPageViewControllerProtocol)
        
        let toVCConfromA = (toVC as? NTTransitionProtocol)
        let toVCConfromB = (toVC as? NTWaterFallViewControllerProtocol)
        let toVCConfromC = (toVC as? NTHorizontalPageViewControllerProtocol)
        if((fromVCConfromA != nil)&&(toVCConfromA != nil)&&(
            (fromVCConfromB != nil && toVCConfromC != nil)||(fromVCConfromC != nil && toVCConfromB != nil))){
                let transition = NTTransition()
                transition.presenting = operation == .Pop
                return  transition
        }else{
            return nil
        }
        
    }
}

class ShowcasesViewController: UICollectionViewController {
    let delegateHolder = NavigationControllerDelegate()
    var collection : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.delegate = delegateHolder
        self.view.backgroundColor = UIColor.whiteColor()
        
        collection = collectionView!
        collection.frame = screenBounds
        //设置布局
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collection.backgroundColor = UIColor.whiteColor()
        collection.registerClass(NTWaterfallViewCell.self, forCellWithReuseIdentifier: waterfallViewCellIdentify)
        
        collection.reloadData()
        
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(waterfallViewCellIdentify, forIndexPath: indexPath) as! NTWaterfallViewCell
        //TODO
        
        collectionCell.setNeedsLayout()
        return collectionCell;
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pageViewController =
        NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
//        pageViewController.imageNameList = imageNameList
        collectionView.setToIndexPath(indexPath)
        navigationController!.pushViewController(pageViewController, animated: true)
    }
    
    func pageViewControllerLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize  = self.navigationController!.navigationBarHidden ?
            CGSizeMake(screenWidth, screenHeight+20) : CGSizeMake(screenWidth, screenHeight-navigationHeaderAndStatusbarHeight)
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        return flowLayout
    }
}

extension ShowcasesViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
         return CGSizeMake(100, 100)
    }
}


extension ShowcasesViewController: NTTransitionProtocol {
    func transitionCollectionView() -> UICollectionView! {
        return collectionView
    }
}

extension ShowcasesViewController: NTWaterFallViewControllerProtocol {
    func viewWillAppearWithPageIndex(pageIndex : NSInteger){
        var position =
        UICollectionViewScrollPosition.CenteredHorizontally.intersect(.CenteredVertically)
        
//        let image:UIImage! = UIImage(named: self.imageNameList[pageIndex] as String)
        
//        let imageHeight = image.size.height*gridWidth/image.size.width
//        if imageHeight > 400 {//whatever you like, it's the max value for height of image
//            position = .Top
//        }
        let currentIndexPath = NSIndexPath(forRow: pageIndex, inSection: 0)
        let collectionView = self.collectionView!;
        collectionView.setToIndexPath(currentIndexPath)
        if pageIndex<2{
            collectionView.setContentOffset(CGPointZero, animated: false)
        }else{
            collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: position, animated: false)
        }
    }
}


