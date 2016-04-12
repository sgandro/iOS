//
//  Utils.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 25/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import UIKit

class Utils{

    static let sharedIstance = Utils()

    class var documentPath: NSURL? {
        get{
            return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        }
    }

    class func existFolder(folder:String?) -> Bool{
        
        guard let folder = folder else{
            return false
        }
        
        return NSFileManager.defaultManager().fileExistsAtPath(folder)
        
    }
    class func existFile(fileName:NSURL) -> Bool{
        
        guard let fileName = fileName.path else{
            return false
        }
        
        return NSFileManager.defaultManager().fileExistsAtPath(fileName)
        
    }
    
    class func createFolder(folder:String) -> NSURL {
        
        let documentDirectoryUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0];
        return documentDirectoryUrl.URLByAppendingPathComponent("\(folder)/");
        
    }
    
    class func getFullFileNameAndPathFromLastPathComponent(fileName:String?) -> NSURL?{
        
        guard let fileName = fileName else { return nil }
        return Utils.documentPath!.URLByAppendingPathComponent(fileName)
    }
    
    class func getFullFileNameAndPathFromSourceURL(url:NSURL?) -> NSURL?{
        
        guard let fileName = url?.lastPathComponent else { return nil }
        return Utils.documentPath!.URLByAppendingPathComponent(fileName)
    }
    
    class func deleteFile(fileName: NSURL?) -> Bool?{
        guard let fileName = fileName?.path else { return false }
        
        let fullFileName = Utils.documentPath!.URLByAppendingPathComponent(fileName)
        let isExist = Utils.existFile(fullFileName)
        do{
            try NSFileManager.defaultManager().removeItemAtPath(fullFileName.path!)
            return true
            
        }catch{
            return isExist ? false : true
        }
    }
    
}