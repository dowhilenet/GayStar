//
//  TrendingDevelope+CoreDataProperties.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/22.
//  Copyright © 2016年 xiaolei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TrendingDevelope {

    @NSManaged var githubname: String?
    @NSManaged var imageURL: String?
    @NSManaged var fullName: String?
    @NSManaged var githubURL: String?
    @NSManaged var repoURL: String?
    @NSManaged var repoName: String?
    @NSManaged var repoDec: String?
    @NSManaged var typeName: String?

}
