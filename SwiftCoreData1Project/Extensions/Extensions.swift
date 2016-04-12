//
//  Extensions.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 18/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//


import Foundation
import UIKit
import CoreData


// MARK: - String

extension String {
    
    var localized: String {
        
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
        
    }
    
    func trimmStringwhitespaceCharacterSet() -> String {
        
        let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return trimmedString
        
    }
    
}



// MARK: - Add AccessoryView to UITextField and UITextView

protocol AccessoryToolbar {
    
    func toolBarWithCloseButton(color: UIColor)
    
    func closeKeyboard()
}

extension UITextField: AccessoryToolbar {
    
    func toolBarWithCloseButton(color: UIColor) {
        
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.barStyle = UIBarStyle.Default
        
        toolbar .userInteractionEnabled = true
        
        toolbar.sizeToFit()
        
        toolbar.tintColor = color
        
        let closeButton = UIBarButtonItem(title: "CHIUDI".localized, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UITextField.closeKeyboard))
        
        if let font: UIFont = UIFont.systemFontOfSize(14.0) {
            
            closeButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, closeButton], animated: false)
        
        self.inputAccessoryView = toolbar
    }
    
    func closeKeyboard() {
        
        self.resignFirstResponder()
        
    }
    
}

extension UITextView: AccessoryToolbar {
    
    func toolBarWithCloseButton(color: UIColor) {
        
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.barStyle = UIBarStyle.Default
        toolbar .userInteractionEnabled = true
        toolbar.sizeToFit()
        toolbar.tintColor = color
        
        let closeButton = UIBarButtonItem(title: "CHIUDI".localized, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UITextField.closeKeyboard))
        
        if let font: UIFont = UIFont.systemFontOfSize(14.0) {
            
            closeButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, closeButton], animated: false)
        
        self.inputAccessoryView = toolbar
    }
    
    func closeKeyboard() {
        
        self.resignFirstResponder()
        
    }
}

//MARK: - NSManagedObjectContext

extension NSManagedObjectContext {
    
    func deleteAllObjectsForEntity(entry: String, context: NSManagedObjectContext? = nil) {
        
        let fetchRequest = NSFetchRequest(entityName: entry)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        if let context = context{
            if context.concurrencyType == .PrivateQueueConcurrencyType{
                //PRIVATE
                context.performBlock({
                    do{
                        try context.executeRequest(deleteRequest)
                    }catch let error as NSError {
                        print("Unresolved error \(error) \(error.userInfo)")
                    }
                })
                
            }else{
                //MAIN
                do{
                    try context.executeRequest(deleteRequest)
                }catch let error as NSError {
                    print("Unresolved error \(error) \(error.userInfo)")
                }
            
            }
        }
        
    }
    func deleteAllObjects() {
        if let entitiesByName = persistentStoreCoordinator?.managedObjectModel.entitiesByName{
            
            for (name, _) in entitiesByName{
                deleteAllObjectsForEntity(name)
            }
            
            return
        }
        return 
    }
    
    
}


//MARK: - Float

extension Float {
    var cleanValue: String {
        return String(format: "%.0f", self)
    }
    var twoDecimalValue: String {
        return String(format: "%.1f", self)
    }

}

extension Double {
    var cleanValue: String {
        return String(format: "%.0f", self)
    }
    var twoDecimalValue: String {
        return String(format: "%.1f", self)
    }
    
}