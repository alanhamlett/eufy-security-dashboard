//
//  ColorManager.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import DynamicColor
import Lorikeet

class ColorManager: NSObject {
    static let shared = ColorManager()
    
    var colors: [String] = ["#6B38EE","#9B6445","#59CB64","#7E5D54","#6E3CFF","#44D7B6","#FF803C","#636BFF","#E21C1C","#F7B500","#3C8EFF","#E54DF6","#6B38EE","#9B6445","#3B98E6","#424CE9","#7F33EB","#FF803C","#FF803C","#636BFF","#E21C1C","#F7B500","#3C8EFF","#E54DF6","#FF67CF","#9B6445","#F7B500","#FF3C78","#EE5151","#56CDDC","#3B98E6","#FF3C78","#EE5151","#56CDDC","#3B98E6","#424CE9","#7F33EB","#7E5D54","#424CE9","#7F33EB","#7E5D54","#6E3CFF","#44D7B6","#FF803C","#636BFF","#E21C1C","#F7B500","#FF67CF","#F7B500","#59CB64","#FF3C78","#F7B500","#59CB64","#FF3C78","#EE5151","#56CDDC","#3B98E6","#F7B500","#7F33EB","#7E5D54","#FF67CF","#44D7B6","#FF67CF","#F7B500","#6B38EE","#FF67CF","#59CB64","#FF3C78","#EE5151","#56CDDC","#3B98E6","#FF803C","#636BFF","#E21C1C","#F7B500","#3C8EFF","#E54DF6","#6B38EE","#9B6445","#59CB64","#FF3C78","#EE5151","#56CDDC","#3B98E6","#424CE9","#7F33EB","#7E5D54","#6E3CFF","#44D7B6","#FF803C","#636BFF","#56CDDC","#59CB64","#44D7B6","#FF803C","#636BFF","#E21C1C","#F7B500","#3C8EFF","#E54DF6","#6B38EE","#9B6445","#59CB64","#FF3C78","#EE5151","#56CDDC","#424CE9","#7F33EB","#7E5D54","#FF67CF","#6E3CFF","#44D7B6","#FF803C","#636BFF","#E21C1C","#F7B500","#3C8EFF","#E54DF6","#6B38EE","#9B6445","#59CB64","#FF3C78","#EE5151","#56CDDC","#3B98E6","#424CE9","#7F33EB","#7E5D54","#6E3CFF","#44D7B6","#FF3C78","#EE5151","#56CDDC","#3B98E6","#424CE9","#7F33EB","#7E5D54","#6E3CFF","#44D7B6","#3B98E6","#424CE9","#7F33EB","#7E5D54","#6E3CFF","#44D7B6","#FF803C","#636BFF","#E21C1C","#F7B500","#3C8EFF","#E54DF6","#6B38EE","#9B6445","#E21C1C","#F7B500","#636BFF","#E21C1C","#FF67CF","#3C8EFF","#E54DF6","#6B38EE","#9B6445"]
    
    var defaultColor = UIColor(hex: 0x8660F3)
    var secondaryColor = UIColor(hex: 0x6E3CFF)
    var accentColor = UIColor(hex: 0xFF3E8E)
    var blue = UIColor(hex: 0x1188FF)
    
    var userColor: UIColor {
        get {
            return colorForText(UserManager.current.name)
        }
    }
    
    override init() {
        super.init()
    }
    
    func colorForText(_ text: String?) -> UIColor {
        guard let text = text, text.count > 0 else { return defaultColor }
        
        let seed = CGFloat(131.0)
        let seed2 = CGFloat(137.0)
        let maxSafeInteger = 9007199254740991.0 / seed2
        let full = CGFloat(360.0)
        
        var hash = CGFloat(0)
        for char in "\(text)x" {
            if let scl = String(char).unicodeScalars.first?.value {
                if hash > maxSafeInteger {
                    hash = hash / seed2
                }
                hash = hash * seed + CGFloat(scl)
            }
        }
        
        let H = (CGFloat(hash).truncatingRemainder(dividingBy: (full - 1.0))) / full
        return UIColor(hexString: colors[Int(H * CGFloat(colors.count))])
    }
}

extension UIColor {
    func colorForText(_ text: String?) -> UIColor {
        return ColorManager.shared.colorForText(text)
    }
}

extension String {
    func color() -> UIColor {
        return ColorManager.shared.colorForText(self)
    }
}
