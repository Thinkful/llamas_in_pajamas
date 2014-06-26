//
//  UIColor+Hex.swift
//  Unit1
//
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(1)
        }
        
        if (countElements(cString) != 6) {
            self.init(white: 0.5, alpha:1.0)
            return;
        }
        
        var rString = cString.substringToIndex(2)
        var gString = cString.substringFromIndex(2).substringToIndex(2)
        var bString = cString.substringFromIndex(4).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner.scannerWithString(rString).scanHexInt(&r)
        NSScanner.scannerWithString(gString).scanHexInt(&g)
        NSScanner.scannerWithString(bString).scanHexInt(&b)
                
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha:1)
    }

}

