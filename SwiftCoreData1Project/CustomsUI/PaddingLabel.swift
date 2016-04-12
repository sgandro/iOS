//
//  PaddingLabel.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 23/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PaddingLabel: UILabel {
    
    @IBInspectable var left: CGFloat = 0.0
    @IBInspectable var top: CGFloat = 0.0
    @IBInspectable var right: CGFloat = 0.0
    @IBInspectable var bottom: CGFloat = 0.0
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
        
    }
    
}