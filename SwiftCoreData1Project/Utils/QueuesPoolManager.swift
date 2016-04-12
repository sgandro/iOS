//
//  QueuesPoolManager.swift
//  SwiftCoreData1Project
//
//  Created by Alessandro Perna on 08/04/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation

class QueuesPoolManager {
    
    static let sharedInstance = QueuesPoolManager()
    
    private var pool: [NSOperationQueue]
    
    
    init(){
        ColorLog.purple("QueuesPoolManager Init")
        pool = [NSOperationQueue]()
    }
    
    func addQueue(queueName: String?) -> NSOperationQueue? {
        
        let queue = NSOperationQueue()
        queue.name = queueName
        
        pool.append(queue)
        return queue
    }
    
    func getQueueByName(queueName: String) -> NSOperationQueue? {

        return pool.filter({ $0.name == queueName }).first
    }
    
    
    func suspendAllOperation(queueName: String? = nil)->Void{

        guard pool.count>0 else { ColorLog.yellow("empty queue"); return }
        
        if queueName != nil{
            
            if let queue: NSOperationQueue = getQueueByName(queueName!){
                if queue.suspended == false {
                    ColorLog.yellow("suspend queue \(queue.name)")
                    queue.suspended = true
                }
            }
        
        }else{
            for queue in pool{
                if queue.suspended == false {
                    ColorLog.yellow("suspend queue \(queue.name)")
                    queue.suspended = true
                }
            }
        
        }
    
    }

    func resumeAllOperation(queueName: String? = nil)->Void{
        
        guard pool.count>0 else { ColorLog.yellow("empty queue"); return }

        if queueName != nil{
            
            if let queue: NSOperationQueue = getQueueByName(queueName!){
                if queue.suspended == true {
                    queue.suspended = false
                    ColorLog.yellow("resume queue \(queue.name)")

                }
            }
            
        }else{
            
            for queue in pool{
                if queue.suspended == true {
                    queue.suspended = false
                    ColorLog.yellow("resume queue \(queue.name)")

                }
            }
            
        }
        
    }

    func deleteAllOperation(queueName: String? = nil)->Void{
        
        if queueName != nil{
            
            if let queue: NSOperationQueue = getQueueByName(queueName!){
                if queue.suspended == true {
                    queue.cancelAllOperations()
                    ColorLog.yellow("cancel all operation in queue \(queue.name)")
                }
            }
            
        }else{
            
            for queue in pool{
                if queue.suspended == true {
                    queue.cancelAllOperations()
                    ColorLog.yellow("cancell all operation in queue \(queue.name)")
                }
            }
            
        }
        
    }

    
}