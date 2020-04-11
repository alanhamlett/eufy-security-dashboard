//
//  FocusIndicatorView.swift
//  Hotline
//
//  Created by James Mudgett on 11/9/19.
//  Copyright © 2019 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import Foundation

public class FocusIndicatorView: UIView {
    
    // MARK: - ivars
    
    internal var _focusRingView: UIImageView?
    
    // MARK: - object lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentMode = .scaleToFill
        self._focusRingView = UIImageView(image: UIImage(named: "focus_indicator"))
        if let focusRingView = self._focusRingView {
            focusRingView.alpha = 0
            self.addSubview(focusRingView)
        }
        self.frame = self._focusRingView?.frame ?? frame
        
        self.prepareAnimation()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self._focusRingView?.layer.removeAllAnimations()
    }
}

// MARK: - animation
extension FocusIndicatorView {

    internal func prepareAnimation() {
        // prepare animation
        self._focusRingView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self._focusRingView?.alpha = 0
    }
    
    public func startAnimation() {
        self._focusRingView?.layer.removeAllAnimations()
        
        // animate
        UIView.animate(withDuration: 0.2) {
            self._focusRingView?.alpha = 1
        }
        UIView.animate(withDuration: 0.5) {
            self._focusRingView?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
    }
    
    public func stopAnimation() {
        self._focusRingView?.layer.removeAllAnimations()
 
        UIView.animate(withDuration: 0.2) {
            self._focusRingView?.alpha = 0
        }
        UIView.animate(withDuration: 0.2, animations: {
            self._focusRingView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (completed) in
            if completed {
                self.removeFromSuperview()
            }
        }
    }
    
}
