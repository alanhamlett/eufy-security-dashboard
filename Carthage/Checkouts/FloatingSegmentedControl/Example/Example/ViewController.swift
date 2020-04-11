//
//  ViewController.swift
//  Example
//
//  Created by Ryuhei Kaminishi on 2019/10/21.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit
import FloatingSegmentedControl

final class ViewController: UIViewController {

    @IBOutlet private weak var segmentedControl1: FloatingSegmentedControl!
    @IBOutlet private weak var segmentedControl2: FloatingSegmentedControl!
    @IBOutlet private weak var segmentedControl3: FloatingSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl1.setSegments(with: [
            "Today", "Days", "Months"
        ])
        segmentedControl1.addTarget(self, action: #selector(update(_:)))
        segmentedControl1.isAnimateFocusMoving = true

        segmentedControl2.setSegments(with: [
            "Left", "Right"
        ])

        segmentedControl2.addTarget(self, action: #selector(update(_:)))
        segmentedControl2.isAnimateFocusMoving = true

        segmentedControl3.setSegments(with: [
            "Left", "Right"
        ])

        segmentedControl3.addTarget(self, action: #selector(update(_:)))
        segmentedControl3.isAnimateFocusMoving = true
    }

    @IBAction func didTap1Button(_ sender: Any) {
        segmentedControl1.move(to: 0)
    }

    @IBAction func didTap2Button(_ sender: Any) {
        segmentedControl1.move(to: 1)
    }

    @IBAction func didTap3Button(_ sender: Any) {
        segmentedControl1.move(to: 2)
    }

    @objc func update(_ sender: FloatingSegmentedControl) {
        print("focused index is \(sender.focusedIndex)")
    }
}

