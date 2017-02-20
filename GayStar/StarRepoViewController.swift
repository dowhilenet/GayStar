//
//  StarRepoViewController.swift
//  GayStar
//
//  Created by xiaolei on 2017/2/20.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit

class StarRepoViewController: UIViewController {

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(StarRepoTableViewCell.self, forCellReuseIdentifier: "starrepo")
    return tableView
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
          make.edges.equalToSuperview()
      }
      
      getStar()
    }
  
  func getStar() {
    githubProvider.request(Github.currentUserStars) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let value):
        let json = try! value.mapJSON()
        print(json)
      }
    }
  }
}

extension StarRepoViewController: UITableViewDelegate {
  
}

extension StarRepoViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "starrepo", for: indexPath) as! StarRepoTableViewCell
    cell.textLabel?.text = "\(indexPath.row)"
    return cell
  }
}
