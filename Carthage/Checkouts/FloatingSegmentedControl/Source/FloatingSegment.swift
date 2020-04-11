//
//  FloatingSegment.swift
//  FloatingSegmentedControl
//
//  Created by Ryuhei Kaminishi on 2019/10/21.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit

class FloatingSegment: UIView, NibInstantiatable {
    @IBOutlet weak var button: UIButton!

    var title: String? {
        get {
            button.currentTitle
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }

    var isAnimateTitleColor = true

    var titleColor: UIColor? {
        get {
            button.titleColor(for: .normal)
        }
        set {
            UIView.transition(with: button,
                              duration: isAnimateTitleColor ? 0.25 : 0.0,
                              options: .transitionCrossDissolve, animations: { self.button.setTitleColor(newValue,
                                                                                                         for: .normal) },
                              completion: nil)
        }
    }

    weak var floatingSegmentedControl: FloatingSegmentedControl?

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func didTapButton(_ sender: UIButton) {
        floatingSegmentedControl?.select(segment: self)
    }

    func setActiveColor() {
        titleColor = .white
    }

    func setInactiveColor() {
        titleColor = .secondaryLabel
    }
}
