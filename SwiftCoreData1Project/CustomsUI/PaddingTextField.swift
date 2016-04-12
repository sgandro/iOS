//
//  PaddingTextField.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 23/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PaddingTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
}