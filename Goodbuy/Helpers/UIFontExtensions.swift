//
//  UIFontExtensions.swift
//  Hotline
//
//  Created by James Mudgett on 1/13/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

/*
 
 Style    Font    Size
 .largeTitle    SFUIDisplay                     34.0
 .title1    SFUIDisplayc(-Light on iOS <=10)    28.0
 .title2    SFUIDisplay                         22.0
 .title3    SFUIDisplay                         20.0
 .headline    SFUIText-Semibold                 17.0
 .callout    SFUIText                           16.0
 .subheadline    SFUIText                       15.0
 .body    SFUIText                              17.0
 .footnote    SFUIText                          13.0
 .caption1    SFUIText                          12.0
 .caption2    SFUIText                          11.0
 
 */
import UIKit

extension UIFont {
    static func roundedFont(ofSize style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        // Will be SF Compact or standard SF in case of failure.
        let fontSize = UIFont.preferredFont(forTextStyle: style).pointSize
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
}
