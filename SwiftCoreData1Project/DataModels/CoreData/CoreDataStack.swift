//
//  CoreDataStack.swift
//  SwiftCoreData1Project
//
//  Created by Alessandro Perna on 04/04/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import CoreData



class CoreDataStack {

    lazy var store: CoreDataStore = {
    
        var store = CoreDataStore()
        return store
    }()
    
    // ritorna una coda per lavorare in background
    func newPrivateQueueContext() -> NSManagedObjectContext? {
        let parentContext = self.mainQueueContext
        
        if parentContext == nil {
            return nil
        }
        
        let privateQueueContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateQueueContext.parentContext = parentContext
        privateQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return privateQueueContext
    }
    
    // ritorna la coda principale
    lazy var mainQueueContext: NSManagedObjectContext? = {
        let parentContext = self.masterContext
        
        if parentContext == nil {
            return nil
        }
        
        var mainQueueContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainQueueContext.parentContext = parentContext
        mainQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return mainQueueContext
    }()
    
    // ritorna il contesto primario
    private lazy var masterContext: NSManagedObjectContext? = {
        
        var masterContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.store.persistentStoreCoordinator
        masterContext.undoManager = nil
        masterContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return masterContext
    }()
    
    // Closure per la gestione della notifica di avvenuto salvataggio dei dati, per sincornizzare i due contesti Master / Private
    var cdn: CoreDataNotification = {
        
        let cdn = CoreDataNotification()
        cdn.didSavedNotification({ (context, notification) in
            
            if context.concurrencyType == .MainQueueConcurrencyType {
                
                context.performBlock {
                    context.mergeChangesFromContextDidSaveNotification(notification)
                }
                
            } else if context.concurrencyType == .PrivateQueueConcurrencyType {
                
                context.performBlock {
                    context.mergeChangesFromContextDidSaveNotification(notification)
                }
                
            } else {
                
                context.performBlock {
                    context.mergeChangesFromContextDidSaveNotification(notification)
                }
                context.performBlock {
                    context.mergeChangesFromContextDidSaveNotification(notification)
                }
            }
        })
        return cdn
    }()
    
    // Salvataggio dei dati in base al contesto
    func saveContext(context: NSManagedObjectContext){
        
        if context.concurrencyType == .PrivateQueueConcurrencyType{
        
            context.performBlock {
                
                if context.hasChanges {
                    
                    do{
                        try context.save()
                    }catch let error as NSError {
                        ColorLog.red("Unresolved error \(error.localizedDescription) \(error.userInfo)")
                    }
                }
            }
        }else{
            
            if context.hasChanges {
                
                do{
                    try context.save()
                }catch let error as NSError {
                    ColorLog.red("Unresolved error \(error.localizedDescription) \(error.userInfo)")
                }
            }
        
        }
        
    }
    

    
}