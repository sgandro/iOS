//
//  Customers.swift
//  
//
//  Created by Alessandro Perna on 22/03/16.
//
//

import Foundation
import CoreData

class Customers: NSManagedObject {

    
    class func createNewCustomerInBackground(customer: CustomerDataObject, moc: NSManagedObjectContext, completed:((object: Customers?, error: NSError?)->Void)?){
        
        moc.performBlock {
            
            
            
            let newCustomer = NSEntityDescription.insertNewObjectForEntityForName(Entities.Customers.rawValue, inManagedObjectContext: moc) as! Customers
            
            newCustomer.nome = customer.nome
            newCustomer.cognome = customer.cognome
            
            if let error = saving(moc) {
                completed?(object: nil, error: error)
            }else{
                completed?(object: newCustomer, error: nil)
            }
            
        }
        
    }
    
    
    override func validateValue(value: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey key: String) throws {
        
        if value == nil {
            return
        }
        
        if
            let valueString = value.memory as? String
            where value.memory != nil
        {
            
            if valueString.isEmpty {
                
                let errorStr = NSLocalizedString("\(key) non può essere vuoto", tableName: "Veichles", comment: "validation: empty error")
                let userInfoDict = [NSLocalizedDescriptionKey: errorStr]
                let error = NSError(domain: "Veichles", code: 1000, userInfo: userInfoDict)
                throw error
                
            }
            
        }else{
            
            let errorStr = NSLocalizedString("\(key) non può essere nullo", tableName: "Veichles", comment: "validation: null error")
            let userInfoDict = [NSLocalizedDescriptionKey: errorStr]
            let error = NSError(domain: "Veichles", code: 1001, userInfo: userInfoDict)
            throw error
            
        }
        
    }


    
    
    //MARK: - Private functions
    
    private class func saving(moc: NSManagedObjectContext) -> NSError?{
        do{
            try moc.save()
        }catch let error as NSError {
            moc.reset()
            ColorLog.red("Saving Customer error \(error) \(error.userInfo)")
            return error
            
        }
        return nil
        
    }

}
