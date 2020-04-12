//
//  GradientBackgroundView.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/11/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

class GradientBackgroundView: UIView {
    init(startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 0, y: 1)) {
        super.init(frame: CGRect.zero)
        configureGradientLayerWithPoints(start: startPoint, end: endPoint)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private func configureGradientLayerWithPoints(start startPoint: CGPoint, end endPoint: CGPoint) {
        guard let gradient = self.layer as? CAGradientLayer else { return }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
    }
}
