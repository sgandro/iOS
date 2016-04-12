//
//  SyncronizeManager.swift
//  SwiftCoreData1Project
//
//  Created by Alessandro Perna on 08/04/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import Alamofire

// Enumeration che indica gli stati del singolo servizio
enum SyncStatus: Int{
    case Registered = 0
    case Running
    case Completed
    case Failed
}

class SyncronizeManager {
    
    typealias SyncCompleted = ((queue: NSOperationQueue?, error: NSError?) ->Void)
    typealias SyncServiceStatus = (entity: Entities, status: SyncStatus)
    
    static let sharedInstance = SyncronizeManager()
    
    // array dei servizi da sincornizzare
    private var syncServices: [SyncServiceStatus]

    private var manyCompletedWithSuccess: Int

    private var connection: ConnectionNotification?
    
    private var apn: ApplicationNotification?

    init(){
    
        ColorLog.purple("SyncronizeManager Init")
        manyCompletedWithSuccess = 0
        syncServices = [SyncServiceStatus]()
        
        // aggiungere il singolo servizio che va sincornizzato all'array syncServices
        let service1: SyncServiceStatus
        service1.entity = Entities.Customers
        service1.status = .Registered
        add(service1)

        
        // aggiungere il singolo servizio che va sincornizzato all'array syncServices
        let service2: SyncServiceStatus
        service2.entity = Entities.Veichles
        service2.status = .Registered
        add(service2)

        
        apn = ApplicationNotification()
        
        apn?.didBackgroundAndForegroundNotification(
            foreground: { (notification) in
                ColorLog.orange("application will Foreground Notification")
            },
            background: { (notification) in
                ColorLog.orange("application Enter Background Notification \nBackground time remaining \(UIApplication.sharedApplication().backgroundTimeRemaining.cleanValue) seconds")
                
        })
        
    }
    
    //MARK: Private Functions
    
    private func add(service: SyncServiceStatus){
        syncServices.append(service)

    }

    private func change(entity: Entities, newStatus: SyncStatus){
        //cambio lo stato del servizio in base all'enum Entities che elenca i servizi presenti nel Core Data
        if let index: Int = self.syncServices.indexOf({ $0.entity == entity }){
            self.syncServices[index].status = newStatus
        }

    }
    
    // verifico lo stato elencato nell'enum SyncStatus del servizio elencato nell'enum Entities
    private func isRegistered(entity: Entities) -> Bool{
        return syncServices.filter({  $0.entity == entity && $0.status == .Registered }).count > 0
    }
    private func isRunning(entity: Entities) -> Bool{
        return syncServices.filter({  $0.entity == entity && $0.status == .Running }).count > 0
    }
    private func isCompleted(entity: Entities) -> Bool{
        return syncServices.filter({  $0.entity == entity && $0.status == .Completed }).count > 0
    }
    private func isFailed(entity: Entities) -> Bool{
        return syncServices.filter({  $0.entity == entity && $0.status == .Failed }).count > 0
    }

    // sincornizzo i servizi in base allo stato elencato nell'enum SyncStatus
    private func syncAll(){

        guard self.manyCompletedWithSuccess < self.syncServices.count else {
            ColorLog.gray("ConnectionNotification delloc")
            self.connection = nil
            return
        }
        
        fillCoreDataForCustomers({ (queue, error) in

            if self.isCompleted(.Customers){
                self.manyCompletedWithSuccess += 1
                ColorLog.gray("Customers syncronized services are \(self.manyCompletedWithSuccess) of \(self.syncServices.count)")
            }
            if self.isFailed(.Customers){
                ColorLog.red("ERROR >>> \n\(error?.localizedDescription)")
            }
            
        })
        fillCoreDataForVeichles({ (queue, error) in
            
            if self.isCompleted(.Veichles){
                self.manyCompletedWithSuccess += 1
                ColorLog.gray("Veichles syncronized services are \(self.manyCompletedWithSuccess) of \(self.syncServices.count)")
            }
            if self.isFailed(.Veichles){
                ColorLog.red("ERROR >>> \n\(error?.localizedDescription)")
            }
            
        })
        
    }
    

    
    //MARK: All Sync Functions
    
    /**
     Sync all services
     
     - parameters: nothing.
     
     - returns: nothing
     */
    
    func syncornizedAllServices(){
    
        ColorLog.bluelight("Sync All Services")
        
        if self.connection == nil{
            
            connection = ConnectionNotification()
            
            connection?.change(
                connected: {
                    self.syncAll()
                },
                disconnect: {
            })
            
        }
        
        downloadFile({ (fileName,error) in
            
            guard error == nil else{
                
                ColorLog.red("ERROR >>> \n\(error?.localizedDescription)")
                return
            }
            
            
            if let fileName = fileName {
                ColorLog.lightgreen("RESULT >>> File downloaded:\(fileName)\n")
                
            }
            
        })


    }
    
    private func fillCoreDataForCustomers(completed: SyncCompleted) -> Request? {
        
        if isRegistered(.Customers) || isFailed(.Customers){
            
            self.change(Entities.Customers, newStatus: .Running)
            
            return Facade.getAllCustomers("https://dl.dropboxusercontent.com/u/6697572/nomi.json") { (queue, error) in
                
                if error == nil {
                    self.change(Entities.Customers, newStatus: .Completed)
                    
                    completed(queue: queue, error: nil)
                }else{
                    self.change(Entities.Customers, newStatus: .Failed)
                    completed(queue: nil, error: error)
                }

            }

        }else{
            ColorLog.gray("\(Entities.Customers) just running")
            completed(queue: nil, error: nil)

        }
        return nil
    }
    
    private func fillCoreDataForVeichles(completed: SyncCompleted) -> Request? {
        
        if isRegistered(.Veichles) || isFailed(.Veichles){
        
            self.change(Entities.Veichles, newStatus: .Running)

            return Facade.getAllVeichles("https://dl.dropboxusercontent.com/u/6697572/veichles.json") { (queue, error) in
                
                if error == nil {
                    self.change(Entities.Veichles, newStatus: .Completed)
                    completed(queue: queue, error: nil)
                }else{
                    self.change(Entities.Veichles, newStatus: .Failed)
                    completed(queue: nil, error: error)
                }

            }
        }else{
            ColorLog.gray("\(Entities.Veichles) just running")
            completed(queue: nil, error: nil)

        }
        
        return nil
    }
    
    
    
    private func downloadFile(completed: ((fileName:String?, error:NSError?) ->Void)){
        
        if let url = NSURL(string: "https://dl.dropboxusercontent.com/u/6697572/D682B491-1F8C-404D-87D9-3CB9146728E0.MOV"){
            
            if let filename: NSURL = Utils.getFullFileNameAndPathFromSourceURL(url){
                ColorLog.bluelight("filename full path : \(filename)")
                if Utils.existFile(filename){
                    //completed(fileName: filename.path, error: nil)
                    //return
                    
                    ColorLog.lightgreen("WARNING  >>> File esistente, lo sovrascrivo")
                    
                }
                Utils.deleteFile(filename)
                
            }
            
            
            Facade.downloadFile(url, completed: { (request, response, data, error) in
                
                if let filename: NSURL = Utils.getFullFileNameAndPathFromSourceURL(response?.URL){
                    if Utils.existFile(filename){
                        completed(fileName: filename.path, error: error)
                    }
                    
                }else{
                    let error = NSError(domain: "SyncronizeManager", code: 0, userInfo: [NSLocalizedDescriptionKey:"Download File failed"])
                    completed(fileName: nil, error: error)
                }
            })
            
            
            
        }else{
            
            let error = NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey:"Url non valido"])
            completed(fileName: nil, error: error)
        }
        
        
    }
}