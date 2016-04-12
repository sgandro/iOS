//
//  CoreDataController.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 22/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import CoreData
import UIKit


// Specifiche per il database attuale

enum Entities: String {
    
    case Customers
    case Veichles
    
}

struct EntitiesCounter{
    
    var Customers: CustomersProgress
    var Veichles: VeichlesProgress
    
}

struct CustomersProgress{
    
    var total: Int
    var actual: Int
}

struct VeichlesProgress{
    
    var total: Int
    var actual: Int
}

// END



enum ConcurrencyQueue: String{
    
    case Private
    case Main
}

struct CustomerDataObject{

    var nome: String?
    var cognome: String?

}

struct VeichleDataObject{
    
    var marca: String?
    var modello: String?
    
}

class CoreDataController{

    typealias CoreDataArrayCompleted = ((objects: [AnyObject]?, error: NSError?)->Void)
    typealias CoreDataSingleCompleted = ((object: AnyObject?, error: NSError?)->Void)
    
    // MARK: - Singleton
    static let sharedInstance = CoreDataController()
    
    var coreDataStack: CoreDataStack
    
    var counters: EntitiesCounter
    
    
    
    
    init(){
        ColorLog.purple("CoreDataController Init")
        coreDataStack = CoreDataStack()
        counters = EntitiesCounter(Customers: CustomersProgress(total: 0, actual: 0), Veichles: VeichlesProgress(total: 0, actual: 0))
        
    }
    
    
    //MARK: Main Queue
    
    /**
     Core Data save context
     
     - parameter context: NSManagedObjectContext
     - returns: nothing
     */
    
    func saveContext (context: NSManagedObjectContext) {
        coreDataStack.saveContext(context)
    }
    
    
    /**
     Core Data fetch data about entity
     
     - parameter entities: Entities
     - parameter context: NSManagedobjectContext
     - parameter sortDescriptiors: NSSortDescriptor array (Optional)
     - parameter completed: Closure that return error, and array of objects
     
     
     - returns: nothing
     */
    func fetchDataFromEntity(entities: Entities, context: NSManagedObjectContext, sortDescriptors:[NSSortDescriptor]? = nil, completed:CoreDataArrayCompleted){
        
        
        let fetchRequest = NSFetchRequest(entityName: entities.rawValue)
        
        if let sortDescriptors = sortDescriptors{
            
            fetchRequest.sortDescriptors = sortDescriptors
            
        }
        
        
        context.performBlock({
            
            do {
                
                let objects = try context.executeFetchRequest(fetchRequest) as [AnyObject]
                completed(objects: objects, error: nil)
                
            } catch let error as NSError {
                ColorLog.red("Unresolved error \(error) \(error.userInfo)")
                completed(objects: nil, error: error)
            }
        })
        
    }
    
    /**
     Remove all Core Data objects about all or specific Entity
     
     - parameter context: NSManagedObjectContext
     - parameter entities: Entities (Optional)
     
     - returns: nothing
     */
    
    func removeAllObjects(context: NSManagedObjectContext, entities: Entities? = nil){
        
        if let entities = entities {
            
            context.deleteAllObjectsForEntity(entities.rawValue, context: context)
            
        }else{
            
            context.deleteAllObjects()
        }


    }
    
    /**
     Remove specific item Core Data objects about specific context
     
     - parameter object: NSManagedObject
     - parameter context: NSManagedObjectContext
     
     - returns: nothing
     */
    
    func removeObject(object: NSManagedObject, context: NSManagedObjectContext){
        context.performBlock { 
            context.deleteObject(object)
            
            do{
                try context.save()
            }catch let error as NSError{
                ColorLog.red("Unresolved error \(error) \(error.userInfo)")
            }
        }
        
    }
    
    
    /**
     Create new Core Data objects about specific context and entity
     
     - parameter entities: Entities
     - parameter context: NSManagedObjectContext
     - parameter object: specific struct about entity
     - parameter completed: Object and Error
     
     - returns: nothing
     */
    
    func createNewObject(entities: Entities, context: NSManagedObjectContext, object: Any, completed:CoreDataSingleCompleted?) {
        
        switch entities{
            
        case .Customers:            
            Customers.createNewCustomerInBackground(object as! CustomerDataObject, moc: context, completed:{ object, error in
                completed?(object: object, error: error)
            })
            
        case .Veichles:
            Veichles.createNewVeichleInBackground(object as! VeichleDataObject, moc: context, completed:{ object, error in
                completed?(object: object, error: error)
            })
        }
        
    }
    

    

    
}