//
//  Star+CoreDataProperties.swift
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

extension Star {

    @NSManaged var autherName: String?
    @NSManaged var autherURL: String?
    @NSManaged var avatarURL: String?
    @NSManaged var decription: String?
    @NSManaged var default_branch: String?
    @NSManaged var forksCount: NSNumber?
    @NSManaged var fullName: String?
    @NSManaged var homePage: String?
    @NSManaged var html: String?
    @NSManaged var htmlURL: String?
    @NSManaged var id: NSNumber?
    @NSManaged var language: String?
    @NSManaged var name: String?
    @NSManaged var openIssuesCount: NSNumber?
    @NSManaged var pushedTime: String?
    @NSManaged var stargazersCount: NSNumber?

}
