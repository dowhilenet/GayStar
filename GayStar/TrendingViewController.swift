//
//  TrendingViewController.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/20.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Kanna
import XLPagerTabStrip

class TrendingViewController: UIViewController {

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TrendingTableViewCell.self, forCellReuseIdentifier: "trendingcell")
    tableView.estimatedRowHeight = 80
    tableView.rowHeight = UITableViewAutomaticDimension
    return tableView
  }()
  
  
  var type: TimeLine = .trendingToday
  
  var repos = [TrendingModel]() {
    didSet{
      self.tableView.reloadData()
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
          make.edges.equalToSuperview()
        }
      
        getTrendData(type: type)
    }
  
  func getTrendData(type: TimeLine) {
    TimeLineProvider.request(type) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let value):
        self.repos = TrendingModel.getTrendingArray(fromData: value.data)
      }
    }
  }

}

extension TrendingViewController: IndicatorInfoProvider {
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    switch type {
    case .trendingToday:
      return IndicatorInfo(title: "Today")
    case .trendingWeek:
      return IndicatorInfo(title: "Week")
    default:
      return IndicatorInfo(title: "Month")
    }
  }
}

extension TrendingViewController: UITableViewDelegate {
  
}

extension TrendingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "trendingcell", for: indexPath) as! TrendingTableViewCell
    cell.setUpCell(trending: repos[indexPath.row])
    return cell
  }
}
