//
//  Customers+CoreDataProperties.swift
//  SwiftCoreData1Project
//
//  Created by Alessandro Perna on 11/04/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Customers {

    @NSManaged var cognome: String?
    @NSManaged var nome: String?

}
