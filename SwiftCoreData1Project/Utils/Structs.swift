//
//  Structs.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 23/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import UIKit

struct GlobalQueueAsyncDispatcher{

    static let MainQueue: dispatch_queue_t = dispatch_get_main_queue()
    static let UserInteractiveQueue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    static let UserInitiatedQueue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    static let UtilityQueue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    static let BackgroundQueue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    static let PriorityHigh: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    static let PriorityLow: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    static let PriorityDefault: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

}




