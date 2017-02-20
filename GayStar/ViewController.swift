//
//  ViewController.swift
//  GayStar
//
//  Created by xiaolei on 2017/1/7.
//  Copyright © 2017年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

  
    
  lazy var testButton: UIButton = {
    let button = UIButton()
    button.setTitle("Go", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(goto), for: .touchUpInside)
    return button
  }()
    
  override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor.white
      view.addSubview(testButton)
      testButton.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
    }
    
    githubProvider.request(Github.currentUser) { (result) in
      switch result {
      case .failure(let error):
        print("\(error.localizedDescription)")
      case .success(let value):
        let user = value.data.mapObject(type: CurrentUser.self)
        print(user!)
      }
    }
  }

    

    
  func goto() {
    GithubOauth.shared.doOAuthGithub(viewController: self)
  }



}



