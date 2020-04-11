//
//  ButtonsHelper.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit

class RoundInterfaceButton: UIButton {
    var cornerRadius: CGFloat = 10
    
    convenience init(radius: CGFloat) {
        self.init(type: .system)
        cornerRadius = radius
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if cornerRadius == -1 {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

extension UIButton {
    func loadingIndicator(_ show: Bool, color: UIColor = .clear) {
        let tag = 808404
        if show {
            self.isEnabled = false
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.color = color
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
