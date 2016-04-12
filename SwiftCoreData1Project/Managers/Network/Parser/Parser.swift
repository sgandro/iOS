//
//  Parser.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 21/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import SwiftyJSON

class Parser {
    
    class func parserCustomersServiceAsync(json: JSON?) -> NSOperationQueue?{
    
        // verifico che ci siano i dati
        guard
            let json = json,
            let queue = QueuesPoolManager.sharedInstance.addQueue(Entities.Customers.rawValue),
            let arrayOfDictionary = json["nomi"].array
            where arrayOfDictionary.count > 0
            else { return nil }
        
        
        if let backgroundContext = CoreDataController.sharedInstance.coreDataStack.newPrivateQueueContext(){
            
            // Svuoto la tabella
            let clean = NSBlockOperation(block: {
                CoreDataController.sharedInstance.removeAllObjects(backgroundContext, entities: .Customers)
            })
            clean.name = "clean"
            clean.completionBlock = {
                ColorLog.yellow("Svuotamento della tabella Customers terminata")
            }
            
            
            
            // Inserisco i nuovi records
            let insert = NSBlockOperation(block: {
                
                CoreDataController.sharedInstance.counters.Customers.total = arrayOfDictionary.count
                
                for item in arrayOfDictionary{
                    
                    let customerData = CustomerDataObject(nome: item["nome"].string, cognome: item["cognome"].string)
                    CoreDataController.sharedInstance.createNewObject(.Customers, context: backgroundContext, object: customerData, completed: { (object, error) in
                        
                        CoreDataController.sharedInstance.counters.Customers.actual += 1
                    })
                }
            })
            insert.addDependency(clean)
            insert.completionBlock = {
                ColorLog.yellow("Ciclo di inserimento dati Customers terminato")
            }
            insert.name = "insert"
            insert.addDependency(clean)
            
            // fetch dei dati
            let fetch = NSBlockOperation(block: {
                
                CoreDataController.sharedInstance.fetchDataFromEntity(.Customers, context: backgroundContext,  completed: { (objects, error) in
                    
                    guard error == nil else {
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchCustomersNotification", object: objects, userInfo: ["error":error!])
                        return
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("FetchCustomersNotification", object: objects)
                    
                })
                
            })
            fetch.name = "fetch"
            fetch.addDependency(insert)
            fetch.completionBlock = {
                ColorLog.yellow("Fetch dei Customers Notificato")
            }
            
            queue.addOperations([clean,insert,fetch], waitUntilFinished: false)
            return queue
            
        }
        
        return nil

    }

    class func parserVeichlesServiceAsync(json: JSON?) -> NSOperationQueue?{
        
        guard
            let json = json,
            let queue = QueuesPoolManager.sharedInstance.addQueue(Entities.Veichles.rawValue),
            let arrayOfDictionary = json["veichles"].array
            where arrayOfDictionary.count > 0
            else { return nil }
        

        
        if let backgroundContext = CoreDataController.sharedInstance.coreDataStack.newPrivateQueueContext(){
            
            // Svuoto la tabella
            let clean = NSBlockOperation(block: {
                CoreDataController.sharedInstance.removeAllObjects(backgroundContext, entities: .Veichles)
            })
            clean.name = "clean"
            
            clean.completionBlock = {
                ColorLog.yellow("Svuotamento della tabella Veichles terminata")
            }
            
            
            // Inserisco i nuovi records
            let insert = NSBlockOperation(block: {
                
                CoreDataController.sharedInstance.counters.Veichles.total = arrayOfDictionary.count
                
                for item in arrayOfDictionary{
                    
                    let veichleData = VeichleDataObject(marca: item["marca"].string, modello: item["modello"].string)
                    CoreDataController.sharedInstance.createNewObject(.Veichles, context: backgroundContext, object: veichleData, completed: { (object, error) in
                        
                        CoreDataController.sharedInstance.counters.Veichles.actual += 1
                    })
                }
            })
            insert.name = "insert"
            insert.addDependency(clean)
            insert.completionBlock = {
                ColorLog.yellow("Ciclo di inserimento dati Veichles terminato")
            }
            
            insert.addDependency(clean)
            
            
            // fetch dei dati
            let fetch = NSBlockOperation(block: {
                
                CoreDataController.sharedInstance.fetchDataFromEntity(.Veichles, context: backgroundContext, completed: { (objects, error) in
                    
                    guard error == nil else {
                        NSNotificationCenter.defaultCenter().postNotificationName("FetchVeichlesNotification", object: objects, userInfo: ["error":error!])
                        return
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("FetchVeichlesNotification", object: objects)

                })
                
            })
            fetch.name = "fetch"
            fetch.addDependency(insert)
            fetch.completionBlock = {
                ColorLog.yellow("Fetch dei Veichles Notificato")
            }
            
            queue.addOperations([clean,insert,fetch], waitUntilFinished: false)
            return queue

        }
        
        return nil
        
    }

}