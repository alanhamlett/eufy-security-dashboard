//
//  FloatingSegmentedControl.swift
//  FloatingSegmentedControl
//
//  Created by Ryuhei Kaminishi on 2019/10/21.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit

open class FloatingSegmentedControl: UIView, NibInstantiatable {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var backgroundView: UIVisualEffectView!
    @IBOutlet private weak var knob: UIView!
    @IBOutlet private weak var knobXMarginConstraint: NSLayoutConstraint!
    @IBOutlet private weak var knobWidthConstraint: NSLayoutConstraint!

    private var knobXMargin: CGFloat = 0

    var segments: [FloatingSegment] {
        stackView.arrangedSubviews as? [FloatingSegment] ?? []
    }

    open weak var target: NSObject?
    public var action: Selector?

    public var isAnimateFocusMoving = false
    public var focusedIndex: Int = 0 {
        didSet {
            let segmentCount = stackView.arrangedSubviews.count
            if focusedIndex >= segmentCount {
                focusedIndex = (segmentCount > 0) ? segmentCount - 1 : 0
            }
            setNeedsLayout()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        backgroundView.layer.cornerCurve = .continuous
        backgroundView.clipsToBounds = true
        knob.layer.cornerCurve = .continuous
        knob.clipsToBounds = true
        knobXMargin = knobXMarginConstraint.constant

        setNeedsLayout()
    }

    override open var intrinsicContentSize: CGSize {
        if segments.isEmpty {
            return CGSize(width: frame.height, height: UIView.noIntrinsicMetric)
        }

        let width = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width + stackView.x * 2
        return CGSize(width: width, height: UIView.noIntrinsicMetric)
    }

    open override func prepareForInterfaceBuilder() {
        invalidateIntrinsicContentSize()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        backgroundView.layer.cornerRadius = backgroundView.bounds.height / 2

        updateFocusSegment()
    }

    /// Add segment elements
    /// - Parameter titles: Segment titles
    public func setSegments(with titles: [String]) {
        removeAllSegments()
        titles.forEach {
            let bundle = Bundle(for: FloatingSegmentedControl.self)
            let segment: FloatingSegment = FloatingSegment.fromNib(inBundle: bundle, filesOwner: nil)
            segment.floatingSegmentedControl = self
            segment.title = $0
            stackView.addArrangedSubview(segment)
        }
    }

    /// Select segment from code
    /// - Parameter index: Destination index
    public func move(to index: Int) {
        if index < segments.count {
            focusedIndex = index
            sendAction()
        } else {
            print("index \(index) is out of index")
        }
    }

    /// Set a function to be called when the button is pressed
    /// - Parameter target: Calling class
    /// - Parameter selector: The function to call
    public func addTarget(_ target: NSObject, action selector: Selector) {
        self.target = target
        self.action = selector
    }


    func select(segment: FloatingSegment) {
        if let targetIndex = index(of: segment) {
            focusedIndex = targetIndex
            sendAction()
        }
    }

    private func setUp() {
        loadNib()
    }

    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let view = FloatingSegmentedControl.fromNib(inBundle: bundle, filesOwner: self)
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view": view]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: ["view" : view]))
    }

    private func updateFocusSegment() {
        knob.layer.cornerRadius = backgroundView.layer.cornerRadius - (backgroundView.bounds.height - knob.bounds.height) / 2
        if focusedIndex < segments.count {
            let targetSegment = segments[focusedIndex]
            let targetFrame = convert(targetSegment.frame, to: targetSegment.superview)

            knob.isHidden = false
            knobWidthConstraint.constant = max(targetFrame.width, knob.height)
            knobXMarginConstraint.constant = targetFrame.origin.x + knobXMargin * 2

            if isAnimateFocusMoving {
                UIView.animateWithSystemMotion({
                    self.backgroundView.layoutIfNeeded()
                }, completion: nil)
            }

            targetSegment.setActiveColor()

            for segment in segments where segment != targetSegment {
                segment.setInactiveColor()
            }
        } else {
            knob.isHidden = true
            knobWidthConstraint.constant = knob.height
            knobXMarginConstraint.constant = knobXMargin
        }
    }

    private func index(of segment: FloatingSegment) -> Int? {
        if segments.contains(segment) {
            return segments.firstIndex(of: segment)
        }
        return nil
    }

    private func removeAllSegments() {
        segments.forEach {
            $0.removeFromSuperview()
        }
    }

    private func sendAction() {
        if let action = action {
            UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
        }
    }
}
