//
//  ConnectionNotification.swift
//  SwiftCoreData1Project
//
//  Created by Alessandro Perna on 08/04/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import ReachabilitySwift


class ConnectionNotification {
    typealias VoidSuccess = (()->Void)
    
    private var reachability: Reachability?
    var connected: VoidSuccess?
    var disconnect: VoidSuccess?
    
    init(){
        ColorLog.purple("ConnectionNotification Init")
    }

    func change(connected connected:VoidSuccess?,disconnect: VoidSuccess?){
        
        self.connected = connected
        self.disconnect = disconnect
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            ColorLog.red("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("ReachabilityChangedNotification", object: self.reachability, queue: nil) { (notification) in
            
            let reachability = notification.object as! Reachability
            
            if reachability.isReachable() {
                if reachability.isReachableViaWiFi() {
                    ColorLog.lightgreen("Reachable via WiFi")
                } else {
                    ColorLog.lightgreen("Reachable via Cellular")
                }
                self.connected?()
            } else {
                ColorLog.lightgreen("Network not reachable")
                self.disconnect?()
            }
        }
        
        
        do{
            try reachability?.startNotifier()
        }catch{
            ColorLog.red("could not start reachability notifier")
        }
        
        
    }
    
    deinit{
        reachability?.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}