//
//  UIColorExtensions.swift
//  Hotline
//
//  Created by James Mudgett on 1/15/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import DynamicColor

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
    
    func vibrant() -> UIColor {
        return self.lighter(amount: 0.18).saturated(amount: 0.3)
    }
    
    func dark() -> UIColor {
        return self.darkened(amount: 0.2).desaturated()
    }
    
    func light() -> UIColor {
        return self.lighter(amount: 0.10)
    }
}
