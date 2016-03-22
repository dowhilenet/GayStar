//
//  CoreDataStack.swift
//  GithubStar
//
//  Created by xiaolei on 16/3/22.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import Foundation


//
//  CoreDataStack.swift
//  CoreDataLearn
//
//  Created by xiaolei on 16/3/3.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import CoreData

class CoreDadaStack {
    
    static let sharedInstance = CoreDadaStack()
    
    private init(){}
    
    /// model Name
    private let modelName = "GithubStar"
    /// Document Directory URL
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
    
    /// Managed Object Model
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }()
    /// Presistent Store Coordinator
    private lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName + ".sqlite")
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption:true]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }catch {
            print("添加持久化存储区错误")
        }
        return coordinator
    }()
    /// Managed Object Context
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    /**
     Save Context Data
     */
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("错误 ❌ \(error.localizedDescription)")
                abort()
            }
        }
    }
}