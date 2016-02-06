//
//  TestViewController.swift
//  GithubStar
//
//  Created by xiaolei on 16/2/6.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let imageView = UIImageView()
//        ShowcasesRequest.requestShowcases()
        
        let url = ShowcasesRealmAction.select().first?.imageurl
        
        Alamofire.request(.GET, url!).responseData({ (res) -> Void in
            guard let data = res.data  , imagedata = NSString(data: data, encoding: NSUTF8StringEncoding)  else { return }
//            let urlpatch = NSBundle.mainBundle().URLForResource("test", withExtension: "svg")
            let patch = PocketSVG.pathFromSVGFileNamed("test").takeUnretainedValue()
            let myShapeLayer = CAShapeLayer()
//            myShapeLayer.lineWidth = 3
            myShapeLayer.path = patch
            self.view.layer.addSublayer(myShapeLayer)
        })
        
        
        
//        self.view.addSubview(imageView)
//        imageView.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(self.view.snp_top).offset(100)
//            make.leading.trailing.equalTo(self.view)
//            make.height.equalTo(200)
//        }
//        imageView.image = UIImage(named: "Oval 32")
        
       
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
