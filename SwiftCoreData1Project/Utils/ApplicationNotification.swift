//
//  ApplicationNotification.swift
//  SwiftCoreData1Project
//
//  Created by Alessandro Perna on 06/04/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import UIKit

class ApplicationNotification{

    
    var foreground:((notification: NSNotification)->Void)?
    var background:((notification: NSNotification)->Void)?
    
    init(){
        ColorLog.purple("ApplicationNotification Init")
    }
    func didBackgroundAndForegroundNotification(foreground foreground:((notification: NSNotification)->Void),background:((notification: NSNotification)->Void)){
    
        self.foreground = foreground
        self.background = background
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: nil) { (notification) in
            self.foreground?(notification: notification)
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
            self.background?(notification: notification)
        }
        

    }
    
    deinit{
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}