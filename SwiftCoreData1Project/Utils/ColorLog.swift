//
//  ColorLog.swift
//  SwiftTemplateProject
//
//  Created by Alessandro Perna on 18/03/16.
//  Copyright © 2016 Alessandro Perna. All rights reserved.
//

import Foundation


struct ColorLog {
    static let ESCAPE = "\u{001b}["
    
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    
    static func red<T>(object: T) {
        print("\(ESCAPE)fg204,0,0;\(object)\(RESET)")
    }
    
    static func green<T>(object: T) {
        print("\(ESCAPE)fg30,138,0;\(object)\(RESET)")
    }
    
    static func blue<T>(object: T) {
        print("\(ESCAPE)fg0,51,204;\(object)\(RESET)")
    }

    static func yellow<T>(object: T) {
        print("\(ESCAPE)fg245,184,1;\(object)\(RESET)")
    }
    
    static func purple<T>(object: T) {
        print("\(ESCAPE)fg255,0,255;\(object)\(RESET)")
    }
    
    static func cyan<T>(object: T) {
        print("\(ESCAPE)fg0,255,255;\(object)\(RESET)")
    }
    
    static func orange<T>(object: T) {
        print("\(ESCAPE)fg255,100,0;\(object)\(RESET)")
    }
    
    static func lightgreen<T>(object: T) {
        print("\(ESCAPE)fg201,255,0;\(object)\(RESET)")
    }

    static func bluelight<T>(object: T) {
        print("\(ESCAPE)fg30,83,255;\(object)\(RESET)")
    }

    static func gray<T>(object: T) {
        print("\(ESCAPE)fg169,169,169;\(object)\(RESET)")
    }

}
