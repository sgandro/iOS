//
//  Popovers.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 24/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import UIKit

class Popovers {

    class func popoverViewController(size: CGSize, delegate: UIPopoverPresentationControllerDelegate, sourceView: UIView) -> UIViewController {
    
        let menuViewController: UIViewController = Storyboards.main.instantiatePopoverViewController()
        
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = size
        
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = delegate
        popoverMenuViewController?.sourceView = sourceView
        popoverMenuViewController?.sourceRect = CGRect( x: sourceView.center.x, y: sourceView.center.y, width: 1, height: 1)

        return menuViewController
    }
    
    
}