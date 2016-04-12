//
//  Storyboards.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 24/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboard {
    static var storyboard: UIStoryboard { get }
    static var identifier: String { get }
}

struct Storyboards{
    
    struct main: Storyboard {
        static let identifier = "Main"
        static var storyboard: UIStoryboard {
            return UIStoryboard(name: self.identifier, bundle: nil)
        }
        static func instantiateLandingPageViewController() -> UIViewController {
            return self.storyboard.instantiateInitialViewController()! as UIViewController
        }
        static func instantiatePopoverViewController() -> UIViewController {
            return self.storyboard.instantiateViewControllerWithIdentifier("popoverViewController") as UIViewController
        }
    }
}