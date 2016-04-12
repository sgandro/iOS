//
//  Facade.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 21/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Facade{

    class func getAllCustomers(url: String, params: [String : AnyObject]? = nil, header:[String: String]? = nil, completed : ((queue : NSOperationQueue?, error: NSError?) -> Void)?) -> Request?{
        
        
        return NetworkServices.sharedIstance.callGetService(url, completed: { (result, error) in
            
            guard error == nil else {
                ColorLog.orange("Network request completed whit error")
                completed?(queue: nil,error: error)
                return
            }
            if let queue: NSOperationQueue = Parser.parserCustomersServiceAsync(result){
                ColorLog.orange("Network request completed")
                completed?(queue: queue, error: nil)
            }else{
                ColorLog.orange("Network request completed")
                completed?(queue: nil, error: error)
            }
            
        })

        
        

    }

    class func getAllVeichles(url: String, params: [String : AnyObject]? = nil, header:[String: String]? = nil, completed : ((queue : NSOperationQueue?, error: NSError?) -> Void)?) -> Request?{
        
        return NetworkServices.sharedIstance.callGetService(url, completed: { (result, error) in
            
            guard error == nil else {
                ColorLog.bluelight("Network request completed whit error")
                completed?(queue: nil,error: error)
                return
            }
            
            if let queue: NSOperationQueue = Parser.parserVeichlesServiceAsync(result){
                ColorLog.orange("Network request completed")
                completed?(queue: queue, error: nil)
            }else{
                ColorLog.orange("Network request completed")
                completed?(queue: nil, error: error)
            }
        })
        
    
        
    }

    
    class func downloadFile(url: NSURL, params: [String : AnyObject]? = nil, header:[String: String]? = nil, completed: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Void) -> Request?{
    
        return NetworkServices.sharedIstance.downaloadFileService(url, params: params, header: header, completed: { (request, response, data, error) in
            
            guard error == nil || error?.code == 516 else {
                completed(request, response, data, error)
                return
            }
            
            completed(request, response, data, nil)
            
            
        })
    }
    
    
    
}