//
//  Config.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 18/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation

enum Environment: String {
    
    case Develop = "DEV"
    case Test = "COL"
    case Production = "PRO"
}

class Config {
    
    class var env: Environment {
        
        get{
            
            if let mode = NSProcessInfo.processInfo().environment["ENV"] {
                
                if mode.containsString(Environment.Develop.rawValue){
                    return Environment.Develop
                }else if mode.containsString(Environment.Test.rawValue){
                    return Environment.Test
                }else if mode.containsString(Environment.Production.rawValue){
                    return Environment.Production
                }
            } else {
                ColorLog.red("Environment variable not set (or not a string)")
                return Environment.Develop
            }
            return Environment.Develop
        }
        
    }
}