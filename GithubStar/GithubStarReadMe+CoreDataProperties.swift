//
//  GithubStarReadMe+CoreDataProperties.swift
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

extension GithubStarReadMe {

    @NSManaged var id: NSNumber?
    @NSManaged var htmlString: String?
    @NSManaged var htmlURL: String?

}
