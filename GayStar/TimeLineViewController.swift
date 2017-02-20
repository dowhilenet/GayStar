//
//  TimeLineViewController.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/18.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import SWXMLHash
import MJRefresh

class TimeLineViewController: UIViewController {
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TimeLineTableViewCell.self, forCellReuseIdentifier: "timelinecell")
    tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { 
      self.page += 1
      self.getTimeLineData(page: self.page)
    })
    tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
      self.page = 1
      self.getTimeLineData(page: self.page)
    })
    return tableView
  }()
  
  
  var page = 1
  
  var timeLines = [TimeLineModel]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "TimeLine"
    view.backgroundColor = UIColor.white
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    getTimeLineData(page: page)
  }
  
  func getTimeLineData(page: Int) {
    TimeLineProvider.request(TimeLine.currentUser(page: page)) { (result) in
      self.tableView.mj_footer.endRefreshing()
      self.tableView.mj_header.endRefreshing()
      switch result  {
      case .failure(let error):
        print("request current user time line is error \(error.localizedDescription)")
      case .success(let value):
        if page == 1 {
          self.timeLines = TimeLineModel.getTimeLines(formData: value.data)
        }else {
          self.timeLines += TimeLineModel.getTimeLines(formData: value.data)
        }
      }
    }
  }
}

extension TimeLineViewController: UITableViewDelegate {
  
}

extension TimeLineViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timeLines.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "timelinecell", for: indexPath) as! TimeLineTableViewCell
    cell.setUpCell(timeLineModel: timeLines[indexPath.row])
    return cell
  }
}
