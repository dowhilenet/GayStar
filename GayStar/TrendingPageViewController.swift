//
//  TrendingPageViewController.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/20.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import XLPagerTabStrip

class TrendingPageViewController: TwitterPagerTabStripViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    automaticallyAdjustsScrollViewInsets = false
    view.backgroundColor = .white
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let today = TrendingViewController()
    today.type = .trendingToday
    let week = TrendingViewController()
    week.type = .trendingWeek
    let month = TrendingViewController()
    month.type = .trendingMonth
    return [today,week,month]
  }
}
