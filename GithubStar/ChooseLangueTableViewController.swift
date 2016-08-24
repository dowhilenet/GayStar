//
//  ChooseLangueTableViewController.swift
//  GITStare
//
//  Created by xiaolei on 15/11/29.
//  Copyright © 2015年 xiaolei. All rights reserved.
//

import UIKit

protocol ChooseLangueTableViewControllerDelegate{
    func didSelectLan(_ lan:String)
}


class LangCell: UITableViewCell{
    
}


class ChooseLangueTableViewController: UITableViewController {

    
    var langues = [String]()
    var delegate:ChooseLangueTableViewControllerDelegate?
    let starsIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var sectionLangues = [String:[String]]()
    var rootviewcontroller: PageMenuViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        initlange()
        self.title = "All Languages"
    }
    
    func initlange(){
    let patch = Bundle.main.url(forResource: "lang", withExtension: "plist", subdirectory: nil)
    let alllangues = NSArray(contentsOf: patch!)
    let langs = (alllangues?.firstObject)! as! NSArray
    langues = langs as! Array
    langues.forEach { (lang) -> () in
        let a = String(lang[lang.startIndex]).uppercased()
        if let _ = sectionLangues[a] {
            sectionLangues[a]?.append(lang)
        }else {
            sectionLangues[a] = [lang]
        }
        }
    self.tableView.register(LangCell.self, forCellReuseIdentifier: "LangueCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return starsIndexTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = starsIndexTitles[section]
        if let lang = sectionLangues[key] {
            return lang.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LangueCell", for: indexPath)
        let key = starsIndexTitles[(indexPath as NSIndexPath).section]
        cell.textLabel?.text = sectionLangues[key]![(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = starsIndexTitles[(indexPath as NSIndexPath).section]
        let lang = sectionLangues[key]![(indexPath as NSIndexPath).row]
        self.delegate = rootviewcontroller
        self.delegate?.didSelectLan(lang)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return starsIndexTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return starsIndexTitles
    }

    
}
