//
//  HanabiCollectionViewLayout.swift
//  GithubStar
//
//  Created by xiaolei on 16/5/12.
//  Copyright © 2016年 xiaolei. All rights reserved.
//


import UIKit

 open class HanabiCollectionViewLayout: UICollectionViewLayout {
     open var standartHeight: CGFloat = 100.0
     open var focusedHeight: CGFloat = 280.0
     open var dragOffset: CGFloat = 180.0
    
    fileprivate var cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // MARK: UICollectionViewLayout
    
    override open func collectionViewContentSize() -> CGSize {
        guard let collectionView = collectionView else {
            return super.collectionViewContentSize
        }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        let contentHeight = CGFloat(itemsCount) * dragOffset + (collectionView.frame.height - dragOffset)
        
        return CGSize(width: collectionView.frame.width, height: contentHeight)
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let proposedItemIndex = roundf(Float(proposedContentOffset.y / dragOffset))
        let nearestPageOffset = CGFloat(proposedItemIndex) * dragOffset
        
        return CGPoint(x: 0.0, y: nearestPageOffset)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedLayoutAttributes.filter { attributes in
            return attributes.frame.intersects(rect)
        }
    }
    
    override open func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        var frame = CGRect.zero
        var y: CGFloat = 0.0
        
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            
            var height = standartHeight
            let currentFocusedIndex = currentFocusedItemIndex()
            let nextItemOffset = nextItemPercentageOffset(forFocusedItemIndex: currentFocusedIndex)
            
            if (indexPath as NSIndexPath).item == currentFocusedIndex {
                y = collectionView.contentOffset.y - standartHeight * nextItemOffset
                height = focusedHeight
            } else if (indexPath as NSIndexPath).item == (currentFocusedIndex + 1) && (indexPath as NSIndexPath).item != itemsCount {
                height = standartHeight + max((focusedHeight - standartHeight) * nextItemOffset, 0)
                
                let maxYOffset = y + standartHeight
                y = maxYOffset - height
            } else {
                y = frame.origin.y + frame.height
            }
            
            frame = CGRect(x: 0, y: y, width: collectionView.frame.width, height: height)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item
            attributes.frame = frame
            
            cachedLayoutAttributes.append(attributes)
            
            y = frame.maxY
        }
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes[(indexPath as NSIndexPath).item]
    }
    
    // MARK: Private methods
    
    fileprivate func currentFocusedItemIndex() -> Int {
        guard let collectionView = collectionView else {
            return 0
        }
        
        return max(0, Int(collectionView.contentOffset.y / dragOffset))
    }
    
    fileprivate func nextItemPercentageOffset(forFocusedItemIndex index: Int) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        return (collectionView.contentOffset.y / dragOffset) - CGFloat(index)
    }
}

