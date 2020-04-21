//
//  CaptureButton.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/13/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import pop

class CaptureButton: UIControl {
    fileprivate let circle = CircleProgress()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(circle)
        
        circle.snp.makeConstraints {
            $0.size.equalTo(90)
            $0.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(progress: CGFloat) {
        circle.progress = progress
    }
    
    func setProgress(progress: CGFloat, animate: Bool) {
        circle.pop_removeAllAnimations()
        
        let clampedProgress = min(max(progress, 0.0), 1.0)
        
        let anim = POPBasicAnimation()
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        anim.duration = Double(abs(circle.progress - clampedProgress) * 10.0)
        anim.fromValue = circle.progress
        anim.toValue = clampedProgress
        anim.beginTime = CACurrentMediaTime()
        
        if let prop = POPAnimatableProperty.property(withName: "circle.progress", initializer: { prop in
            guard let prop = prop else {
                return
            }
            
            prop.readBlock = { obj, values in
                guard let obj = obj as? CircleProgress, let values = values else {
                    return
                }

                values[0] = obj.progress
            }
            
            prop.writeBlock = { obj, values in
                guard let obj = obj as? CircleProgress, let values = values else {
                    return
                }

                obj.progress = values[0]
            }
            
            prop.threshold = 0.01
        }) as? POPAnimatableProperty {
            anim.property = prop
        }
        
        circle.pop_add(anim, forKey: "circle.progress")
    }
    
    func reset() {
        circle.pop_removeAllAnimations()
        
        let anim = POPBasicAnimation()
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.duration = 0.25
        anim.fromValue = circle.progress
        anim.toValue = 0
        anim.beginTime = CACurrentMediaTime()
        
        if let prop = POPAnimatableProperty.property(withName: "circle.progress", initializer: { prop in
            guard let prop = prop else {
                return
            }
            
            prop.readBlock = { obj, values in
                guard let obj = obj as? CircleProgress, let values = values else {
                    return
                }

                values[0] = obj.progress
            }
            
            prop.writeBlock = { obj, values in
                guard let obj = obj as? CircleProgress, let values = values else {
                    return
                }

                obj.progress = values[0]
            }
            
            prop.threshold = 0.01
        }) as? POPAnimatableProperty {
            anim.property = prop
        }
        
        circle.pop_add(anim, forKey: "circle.progress")
    }
}

class CircleProgress: UIView {
    var progress: CGFloat = 0.0 {
        didSet(value) {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        ColorManager.shared.accentColor.setFill()
        let centerPath = UIBezierPath(ovalIn:bounds)
        centerPath.fill()
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(7.0);
            UIColor(white: 1, alpha: 0.5).set()
            
            
            // Outline
            let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let radius = (bounds.size.width - 7) / 2
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            context.strokePath()
            
            if progress > 0 {
                // Progress Outline
                let progressValue = min(progress, 1.0 - CGFloat(Float.ulpOfOne))
                let startRadians = CGFloat(Double.pi / 2) * 3
                let endRadians = (progressValue * 2.0 * CGFloat(Double.pi)) - CGFloat(Double.pi / 2)
                
                ColorManager.shared.accentColor.set()
                context.setLineWidth(7.3);
                context.addArc(center: center, radius: radius + 0.15, startAngle: startRadians, endAngle: endRadians, clockwise: false)
                context.strokePath()
            }
        }
    }
}

extension CGFloat {
    var degreesToRadians : CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
