//
//  TipBubbleView.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import pop

class TipBubbleView: UIView {
    fileprivate let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.roundedFont(ofSize: .subheadline, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blurView)
        blurView.contentView.addSubview(label)
        
        blurView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(0)
            $0.width.greaterThanOrEqualTo(90).priority(.medium)
            $0.width.lessThanOrEqualTo(228).priority(.high)
        }
        
        label.snp.makeConstraints {
            $0.left.right.equalTo(blurView).inset(10)
            $0.top.bottom.equalTo(blurView).inset(8)
        }
        
        alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let roundPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        blurView.layer.mask = maskLayer
    }
    
    func show() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
            anim.toValue = NSValue(cgSize: CGSize(width: 1.08, height: 1.08))
            anim.autoreverses = true
            anim.springBounciness = 8
            anim.springSpeed = 20
            layer.pop_add(anim, forKey: "size")
        }
        
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewAlpha) {
            anim.fromValue = 0
            anim.toValue = 1
            anim.springBounciness = 4
            anim.springSpeed = 20
            pop_add(anim, forKey: "alpha")
        }
    }
    
    func hide() {
        guard alpha > 0 else { return }
        
        if let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY) {
            anim.toValue = NSValue(cgSize: CGSize(width: 0.60, height: 0.60))
            anim.springBounciness = 4
            anim.springSpeed = 20
            layer.pop_add(anim, forKey: "size")
        }
        
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewAlpha) {
            anim.fromValue = 1
            anim.toValue = 0
            anim.springBounciness = 4
            anim.springSpeed = 20
            pop_add(anim, forKey: "alpha")
        }
    }
}
