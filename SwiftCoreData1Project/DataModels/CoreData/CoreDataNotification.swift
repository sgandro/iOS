//
//  CoreDataNotification.swift
//  SwiftCoreData1Project
//
//  Created by Alessandro Perna on 05/04/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import CoreData

class CoreDataNotification{

    var progress:((entities: Entities)->Void)?
    var saving:((context: NSManagedObjectContext, notification: NSNotification)->Void)?
    var fetch:((objects: [AnyObject]?)->Void)?

    init(){
        ColorLog.purple("CoreDataNotification init")
    }
    
    
    /**
     Closure about Core Data Change Context Notification for entity
     
     - returns: Entities Case
     */
    
    func didProgressNotification(progress:((entities: Entities)->Void)?){
        
        self.progress = progress
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: nil, queue: nil) { (notification) in
                        
            if
                let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? NSSet,
                let obj = insertedObjects.anyObject() as? NSManagedObject,
                let entityName = obj.entity.name,
                let entities: Entities = Entities(rawValue: entityName)
            {
                self.progress?(entities: entities)
            }
        }
    }

    /**
     Closure about Core Data Save Notification
     
     - returns: Context saved and notification
     */
    
    func didSavedNotification(saving:((context: NSManagedObjectContext, notification: NSNotification)->Void)?){
        
        
        self.saving = saving
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) { (notification) in
            
            let context = notification.object as! NSManagedObjectContext
            
            self.saving?(context: context, notification: notification)
        }
        
    }
    
    /**
     Closure about Core Data custom fetch notification
     
     - returns: Array of objects
     */

    func didFetchNotification(fetch:((objects: [AnyObject]?)->Void)?){
        
        self.fetch = fetch
        
        NSNotificationCenter.defaultCenter().addObserverForName("FetchCustomersNotification", object: nil, queue: nil) { (notification) in
            
            if let customers = notification.object as? [AnyObject]{
                self.fetch?(objects: customers)
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("FetchVeichlesNotification", object: nil, queue: nil) { (notification) in
            
            if let veichles = notification.object as? [AnyObject]{
                self.fetch?(objects: veichles)
            }
        }
    }


    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}