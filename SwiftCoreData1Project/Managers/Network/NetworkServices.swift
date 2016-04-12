//
//  NetworkServices.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 18/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 Responsible for Network Services comunication
 */

class NetworkServices {
    
    static let sharedIstance = NetworkServices()
    
    lazy var backgroundManager: Alamofire.Manager = {
        let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(bundleIdentifier! + ".background")
        configuration.sessionSendsLaunchEvents = true
        configuration.discretionary = true
        configuration.timeoutIntervalForRequest = 5 * 60
        configuration.timeoutIntervalForResource = 5 * 60
        configuration.HTTPMaximumConnectionsPerHost = 5
        return Alamofire.Manager(configuration: configuration)
        
    }()
    
    var progress:((percentage: Float)->Void)?

    
    
    // MARK: - Progress download file
    
    /**
     Get Progress notification information
     
     - parameter filename: name of file.

     - returns: Return percentage float
     */
    
    func didProgressNotification(fileName: String, progress:((percentage: Float)->Void)?){
        
        self.progress = progress
        
        NSNotificationCenter.defaultCenter().addObserverForName("DownaloadFileServiceNotification", object: nil, queue: nil) { (notification) in
            
            if let percentage = notification.userInfo?[fileName] as? NSNumber
            {
                self.progress?(percentage: percentage.floatValue)
            }
        }
    }
    
    // MARK: - GET Request
    
    /**
    Call GET Method Serivices
    
    
    - parameter url: url string.
    - parameter params: [String : AnyObject] parameters (Optional).
    - parameter header: [String: String] header parameters (Optional).
    
    - returns: Returns Request object (Optional)
    */
    
    func callGetService(url: String,
                        params: [String : AnyObject]? = nil,
                        header:[String: String]? = nil,
                        completed : ((result : JSON?, error: NSError?) -> Void)?) -> Request? {
        
        
        ColorLog.blue("Environment \(Config.env)")
        ColorLog.cyan("GET REQUEST \nurl: \(url) \nparams: \(params) \nheader: \(header)")
        
        
        return Alamofire.request(.GET, url, parameters: params, encoding: .JSON, headers: header)
            .validate(statusCode: 200..<600)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    
                    completed?(result : nil, error: response.result.error)
                    
                    return
                }
                
                guard let _ = response.result.value as? [String: AnyObject] else {
                    
                    let localErr = NSError(domain: "NetworkServices", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid tag information received from service"])
                    
                    completed?(result : nil, error: localErr)
                    
                    return
                }
                
                guard let data = response.data else{
                    
                    let localErr = NSError(domain: "NetworkServices", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid tag information received from service"])
                    
                    completed?(result : nil, error: localErr)
                    
                    return
                }
                
                
                completed?(result : JSON(data: data), error: nil)
                
        }        
    }
    
    // MARK: - POST Request
    
    /**
    Call POST Method Serivices
    
    
    - parameter url: url string.
    - parameter params: [String : AnyObject] parameters (Optional).
    - parameter header: [String: String] header parameters (Optional).
    
    - returns: Returns Request object (Optional)
    */
    
    func callPostService(url: String,
                         params: [String : AnyObject]? = nil,
                         header:[String: String]? = nil,
                         completed : ((result : JSON?, error: NSError?) -> Void)?) -> Request? {
        
        ColorLog.blue("Environment \(Config.env)")
        ColorLog.cyan("POST REQUEST \nurl: \(url) \nparams: \(params) \nheader: \(header)")
        
        return Alamofire.request(.POST, url, parameters: params, encoding: .JSON, headers: header)
            .validate(statusCode: 200..<600)
            .responseJSON { response in
                
                guard response.result.isSuccess else {

                    completed?(result : nil, error: response.result.error)
                    
                    return
                }
                
                guard (response.result.value as? [String: AnyObject]) != nil else {

                    let localErr = NSError(domain: "NetworkServices", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid tag information received from service"])
                    
                    completed?(result : nil, error: localErr)

                    return
                }
                
                guard let data = response.data else{
                    
                    let localErr = NSError(domain: "NetworkServices", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid tag information received from service"])
                    
                    completed?(result : nil, error: localErr)
                
                    return
                }
                                
                completed?(result : JSON(data: data), error: nil)

                
                
        }
    }
    
    
    
    // MARK: - Public Methods ------------------------------------------------------------------------------------------------------------------------

    // MARK: - Download File Background
    
    
    
    /**
     Download single file
     
     
     - parameter url: url string.
     - parameter params: [String : AnyObject] parameters (Optional).
     - parameter header: [String: String] header parameters (Optional).
     
     - returns: Returns Request object (Optional)
     */
    
    func downaloadFileService(url: NSURL, params: [String : AnyObject]? = nil, header:[String: String]? = nil,completed : (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Void) -> Request?{
        
        ColorLog.blue("Environment \(Config.env)")
        ColorLog.cyan("GET REQUEST \nurl: \(url) \nparams: \(params) \nheader: \(header)")

        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    
        backgroundManager.startRequestsImmediately = true
        
        return backgroundManager.download(.GET, url, parameters: params, encoding: .URL, headers: header, destination: destination)
            .progress({ bytesRead, totalBytesRead, totalBytesExpectedToRead in
                
                let percentage: Float = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                
                dispatch_async(GlobalQueueAsyncDispatcher.PriorityDefault, {
                    NSNotificationCenter.defaultCenter().postNotificationName("DownaloadFileServiceNotification", object: nil, userInfo: [url.lastPathComponent! : NSNumber(float: percentage)])
                })
                
            })
            .response { (request, response, data, error) -> Void in
                
                completed(request, response, data, error)
        }
    }
    
}


