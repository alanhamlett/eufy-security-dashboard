/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

enum PopupViewDismissType: Int {
    case dont
    case deny
    case noAnimation
    case normal
    case flyUp
    case flyDown
    case scaleDown
}

enum PopupViewShowType: Int {
    case normal
    case flyUp
    case flyDown
}

enum PopupViewAlignment: Int {
    case top
    case middle
    case bottom
}

enum PopupViewStyle: Int {
    case dialog
    case sheet
}

protocol PopupViewDelegate {
    func popupViewDidShow(_ popupView: PopupView) -> Void
    func popupViewShouldDismiss(_ popupView: PopupView) -> Bool
    func popupViewDidDismiss(_ popupView: PopupView) -> Void
}

class ButtonData: NSObject {
    var title: String = ""
    var isDefault: Bool = true
    var button: UIButton?
    var handler: (() -> PopupViewDismissType)?
}

class PopupView: UIView, UIGestureRecognizerDelegate {
    static let popupView = PopupView()
    
    fileprivate var keyboardState: KeyboardState?
    
    let kPopupDialogPadding: CGFloat = 20.0
    let kPopupDialogButtonHeight: CGFloat = 44.0
    let kPopupDialogMaxWidth: CGFloat = 394.0
    
    fileprivate let kPopupBackgroundAlpha: CGFloat = 0.3
    fileprivate let kPopupBackgroundDismissTouchDuration: Double = 0.005
    fileprivate let kPopupDialogShakeAngle: CGFloat = 0.2
    fileprivate let kPopupDialogCornerRadius: CGFloat = 10.0
    fileprivate let kPopupDialogButtonRadius: CGFloat = 10.0
    fileprivate let kPopupDialogButtonPadding: CGFloat = 16.0
    fileprivate let kPopupDialogButtonSpacing: CGFloat = 8.0
    fileprivate let kPopupDialogButtonTextSize: CGFloat = 18.0

    
    var showHandler: (() -> Void)?
    var dismissHandler: (() -> Void)?

    var dialogWidth: CGFloat {
        get {
            return style == .dialog ? min(UIScreen.main.bounds.width - padding * 2.0, kPopupDialogMaxWidth) : UIScreen.main.bounds.width
        }
    }
    
    var dialogView: UIVisualEffectView!
    var overlayView: UIView!
    var contentView: UIView!
    
    var style: PopupViewStyle!
    var verticalAlignment: PopupViewAlignment = .middle
    var defaultShowType: PopupViewShowType = .normal
    var defaultDismissType: PopupViewDismissType = .normal
    var overlayDismisses: Bool = true
    var overlayDismissHandler: (() -> Bool)?
    var presentsOverWindow: Bool = true
    var automaticallyMovesWithKeyboard: Bool = true
    var padding: CGFloat = 20.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var dialogButtons: Array<ButtonData> = []
    var dialogButtonsContainer: UIView!
    var dialogButtonDefaultTextColor: UIColor = .white
    var dialogButtonDefaultBackgroundColor: UIColor = .black
    var dialogButtonTextColor: UIColor = .white
    var dialogButtonBackgroundColor: UIColor = UserColor
    
    var delegate: PopupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let touchRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(backgroundTapped(recognizer:)))
        touchRecognizer.minimumPressDuration = kPopupBackgroundDismissTouchDuration
        touchRecognizer.delegate = self
        
        overlayView = UIView(frame: bounds)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.backgroundColor = .black
        overlayView.addGestureRecognizer(touchRecognizer)
        addSubview(overlayView)
        
        dialogButtonsContainer = UIView(frame: CGRect.zero)
        dialogButtonsContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        dialogView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        dialogView.clipsToBounds = true
        dialogView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        dialogView.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        setStyle(popupStyle: .dialog)
        
        KeyboardHelper.defaultHelper.addDelegate(delegate: self)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        let contentSize: CGSize = contentView.frame.size
        let keyboardHeight = KeyboardHelper.defaultHelper.height()
        
        dialogView.frame = _dialogFrameWithKeyboardHeight(height: keyboardHeight)
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: dialogView.bounds.size.width, height: contentSize.height)
        
        // Add and create buttons as necessary.
        if dialogButtons.count > 0 {
            var buttonWidth: CGFloat = 0.0
            
            dialogButtonsContainer.frame = CGRect(x: 0.0, y: contentSize.height, width: dialogView.frame.size.width, height: kPopupDialogButtonHeight)
            
            buttonWidth = dialogView.frame.width - (kPopupDialogButtonPadding * 2.0)
            buttonWidth -= CGFloat((dialogButtons.count-1)) * kPopupDialogButtonSpacing
            buttonWidth = buttonWidth / CGFloat(dialogButtons.count)
            buttonWidth = rint(buttonWidth)
            
            var buttonFrame: CGRect = CGRect(x: kPopupDialogButtonPadding, y: 0, width: buttonWidth, height: kPopupDialogButtonHeight)
            let defaultButtonFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold)
            let normalButtonFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold)
            
            for buttonData in dialogButtons {
                var button: UIButton? = buttonData.button
                if button == nil {
                    let defaultButton: Bool = buttonData.isDefault
                    button = RoundInterfaceButton(radius: kPopupDialogButtonRadius)
                    button!.titleLabel!.font = defaultButton ? defaultButtonFont : normalButtonFont
                    button!.backgroundColor = defaultButton ? dialogButtonDefaultBackgroundColor : dialogButtonBackgroundColor
                    button!.setTitle(buttonData.title, for: .normal)
                    button!.setTitleColor(defaultButton ? dialogButtonDefaultTextColor : dialogButtonTextColor, for: .normal)
                    button!.addTarget(self, action: #selector(dialogButtonTapped(button:)), for: .touchUpInside)
                    buttonData.button = button
                    dialogButtonsContainer.addSubview(button!)
                }
                
                button?.frame = buttonFrame
                buttonFrame.origin.x += buttonFrame.size.width + kPopupDialogButtonSpacing
            }
            
            dialogView.contentView.addSubview(dialogButtonsContainer)
        }
    }
    
    @discardableResult fileprivate func _dialogFrameWithKeyboardHeight(height: CGFloat) -> CGRect {
        var visibleFrame: CGRect = bounds
        var dialogFrame: CGRect = CGRect.zero
        let contentSize: CGSize = contentView.frame.size
        var dialogSize: CGSize = CGSize(width: dialogWidth, height: contentSize.height)
        
        if dialogButtons.count > 0 {
            dialogSize.height += kPopupDialogButtonHeight
            dialogSize.height += kPopupDialogButtonPadding
        }
        
        if automaticallyMovesWithKeyboard && height > 0 {
            visibleFrame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: UIScreen.main.bounds.height - height)
        }
        
        if !dialogView.transform.isIdentity {
            dialogSize = dialogSize.applying(dialogView.transform)
        }
        
        dialogFrame = CGRect(x: rint(visibleFrame.midX - (dialogSize.width / 2.0)), y: rint(visibleFrame.midY - (dialogSize.height / 2.0)), width: dialogSize.width, height: dialogSize.height)
        dialogFrame.origin.y = max(dialogFrame.origin.y, padding)
        
        if verticalAlignment == .top {
            dialogFrame.origin.y = visibleFrame.origin.y
        }
        else if verticalAlignment == .bottom {
            dialogFrame.origin.y = visibleFrame.size.height - dialogFrame.size.height
        }
        
        return dialogFrame
    }
    
    // MARK: Presentation
    
    func show() {
        showWithType(showType: defaultShowType)
    }
    
    func showWithType(showType: PopupViewShowType) {
        if superview != nil { return }
        
        dialogView.removeFromSuperview()
        
        frame = UIScreen.main.bounds
        
        addSubview(dialogView)
        setNeedsLayout()
        layoutIfNeeded()
        
        if showType == .flyUp {
            let finalFrame: CGRect = dialogView.frame
            var startFrame: CGRect = dialogView.frame
            startFrame.origin.y = frame.maxY
            dialogView.frame = startFrame
            
            // For subclasses.
            willShowWithType(showType: showType)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                self.dialogView.frame = finalFrame
            }, completion: nil)
        }
        else if showType == .flyDown {
            let finalFrame: CGRect = dialogView.frame
            var startFrame: CGRect = dialogView.frame
            startFrame.origin.y = -dialogView.frame.height
            dialogView.frame = startFrame
            
            willShowWithType(showType: showType)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                self.dialogView.frame = finalFrame
            }, completion: nil)
        }
        else if showType == .normal {
            let finalFrame: CGRect = dialogView.frame
            var startFrame: CGRect = dialogView.frame
            startFrame.origin.y = startFrame.origin.y + 30
            dialogView.frame = startFrame
            dialogView.alpha = 0
            
            willShowWithType(showType: showType)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 7.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                self.dialogView.frame = finalFrame
                self.dialogView.alpha = 1
            }, completion: nil)
        }
        
        overlayView.alpha = 0.0
        
        if presentsOverWindow {
            KeyWindow?.addSubview(self)
        } else {
            KeyWindow?.rootViewController?.view.addSubview(self)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            self.overlayView.alpha = self.kPopupBackgroundAlpha
        }, completion: nil)
        
        didShowWithType(showType: showType)
        
        showHandler?()
        
        delegate?.popupViewDidShow(self)
        
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    func dismiss() {
        dismissWithType(dismissType: defaultDismissType)
    }
    
    func dismissWithType(dismissType: PopupViewDismissType) {
        if dismissType == .dont {
            return
        }
        
        if delegate?.popupViewShouldDismiss(self) == false {
            return
        }
        
        if dismissType != .deny {
            self.endEditing(true)
        }
        
        if dismissType == .deny {
            let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
            animation.duration = 0.06
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.isRemovedOnCompletion = true
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.values = [NSValue(caTransform3D: CATransform3DMakeRotation(kPopupDialogShakeAngle, 0.0, 0.0, 1.0)), NSValue(caTransform3D: CATransform3DMakeRotation(-kPopupDialogShakeAngle, 0.0, 0.0, 1.0))]
            dialogView.layer.add(animation, forKey: "dialog.shake")
        }
        else if dismissType == .noAnimation {
            willDismissWithType(dismissType: dismissType)
            removeFromSuperview()
            didDismissWithType(dismissType: dismissType)
            delegate?.popupViewDidDismiss(self)
            dismissHandler?()
        }
        else if dismissType == .normal {
            willDismissWithType(dismissType: dismissType)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                self.alpha = 0.0
            }, completion: { (finished) in
                self.removeFromSuperview()
                self.alpha = 1.0
                self.didDismissWithType(dismissType: dismissType)
                self.delegate?.popupViewDidDismiss(self)
                self.dismissHandler?()
            })
        }
        else if dismissType == .scaleDown {
            willDismissWithType(dismissType: dismissType)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                self.alpha = 0.0
                self.dialogView.transform = self.dialogView.transform.scaledBy(x: 0.9, y: 0.9)
            }, completion: { (finished) in
                self.removeFromSuperview()
                self.alpha = 1.0
                self.dialogView.transform = CGAffineTransform.identity
                self.didDismissWithType(dismissType: dismissType)
                self.delegate?.popupViewDidDismiss(self)
                self.dismissHandler?()
            })
        }
        else if dismissType == .flyUp {
            willDismissWithType(dismissType: dismissType)
            
            overlayView.alpha = kPopupBackgroundAlpha
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                var flyawayFrame: CGRect = self.dialogView.frame
                flyawayFrame.origin.y = -flyawayFrame.height
                flyawayFrame.origin.y -= 20.0
                self.dialogView.frame = flyawayFrame
                self.overlayView.alpha = 0.0
            }, completion: { (finished) in
                self.removeFromSuperview()
                self.overlayView.alpha = self.kPopupBackgroundAlpha
                self.didDismissWithType(dismissType: dismissType)
                self.delegate?.popupViewDidDismiss(self)
                self.dismissHandler?()
            })
        }
        else if dismissType == .flyDown {
            willDismissWithType(dismissType: dismissType)
            
            overlayView.alpha = kPopupBackgroundAlpha
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                var flyawayFrame: CGRect = self.dialogView.frame
                flyawayFrame.origin.y = self.overlayView.bounds.height
                flyawayFrame.origin.y += 20.0
                self.dialogView.frame = flyawayFrame
                self.overlayView.alpha = 0.0
            }, completion: { (finished) in
                self.removeFromSuperview()
                self.overlayView.alpha = self.kPopupBackgroundAlpha
                self.didDismissWithType(dismissType: dismissType)
                self.delegate?.popupViewDidDismiss(self)
                self.dismissHandler?()
            })
        }
    }
    
    // MARK: Options
    
    func setStyle(popupStyle: PopupViewStyle) {
        style = popupStyle
        
        switch popupStyle {
        case .dialog:
            dialogView.layer.cornerRadius = kPopupDialogCornerRadius
            defaultShowType = .flyUp
            defaultDismissType = .flyDown
            verticalAlignment = .middle
            padding = kPopupDialogPadding
        case .sheet:
            dialogView.clipsToBounds = true
            dialogView.layer.cornerRadius = 12
            dialogView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            defaultShowType = .flyUp
            defaultDismissType = .flyDown
            verticalAlignment = .bottom
            padding = 0.0
        }
        
        setNeedsLayout()
    }
    
    func setVerticalAlignment(alignment: PopupViewAlignment) {
        verticalAlignment = alignment
        setNeedsLayout()
    }
    
    func setDialogColor(color: UIColor) {
        dialogView.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func setOverlayColor(color: UIColor, animate: Bool) {
        if !animate {
            overlayView.backgroundColor = color
        }
        else {
            UIView.animate(withDuration: 0.35, delay: 0.0, options: [.beginFromCurrentState], animations: {
                self.overlayView.backgroundColor = color
            }, completion: nil)
        }
    }
    
    func setButtonTextColor(color: UIColor) {
        dialogButtonTextColor = color
        
        for buttonData in dialogButtons {
            if let button: UIButton = buttonData.button {
                button.setTitleColor(color, for: .normal)
            }
        }
    }
    
    func setButtonBackgroundColor(color: UIColor) {
        dialogButtonBackgroundColor = color
        
        let fadeTransition: CATransition = CATransition()
        fadeTransition.type = CATransitionType.fade
        fadeTransition.duration = 0.2
        dialogButtonsContainer.layer.add(fadeTransition, forKey: kCATransition)
        
        for buttonData in dialogButtons {
            if let button: UIButton = buttonData.button {
                button.layer.add(fadeTransition, forKey: kCATransition)
                button.backgroundColor = color
            }
        }
    }
    
    func setPopupContentView(view: UIView) {
        contentView?.removeFromSuperview()
        contentView = view
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dialogView.contentView.addSubview(contentView)
        setNeedsLayout()
    }
    
    func addDefaultButton(title: String, tapped: (() -> PopupViewDismissType)?) {
        let buttonData: ButtonData = ButtonData()
        buttonData.title = title
        buttonData.isDefault = true
        buttonData.handler = tapped
        dialogButtons.append(buttonData)
    }
    
    func addButton(title: String, tapped: (() -> PopupViewDismissType)?) {
        let buttonData: ButtonData = ButtonData()
        buttonData.title = title
        buttonData.isDefault = false
        buttonData.handler = tapped
        dialogButtons.append(buttonData)
        setNeedsLayout()
    }
    
    func setTitle(title: String, buttonIndex: Int) {
        if buttonIndex >= dialogButtons.count {
            return
        }
        
        let buttonData: ButtonData = dialogButtons[buttonIndex]
        buttonData.title = title
        
        if let button = buttonData.button {
            button.setTitle(title, for: .normal)
        }
    }
    
    func removeButtonAtIndex(buttonIndex: Int) {
        if buttonIndex >= dialogButtons.count {
            return
        }
        
        let buttonData: ButtonData = dialogButtons[buttonIndex]
        if let button = buttonData.button {
            button.removeFromSuperview()
        }
        
        dialogButtons.remove(at: buttonIndex)
        setNeedsLayout()
    }
    
    func numberOfButtons() -> Int {
        return dialogButtons.count
    }
    
    // MARK: Actions
    
    @objc func dialogButtonTapped(button: UIButton) {
        var dismissType = defaultDismissType
        
        for buttonData in dialogButtons {
            if let target = buttonData.button {
                if target == button {
                    if let handler = buttonData.handler {
                        dismissType = handler()
                        break
                    }
                }
            }
        }
        
        dismissWithType(dismissType: dismissType)
    }
    
    // MARK: Background
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point: CGPoint = touch.location(in: dialogView)
        return dialogView.point(inside: point, with: nil) == false
    }
    
    @objc func backgroundTapped(recognizer: AnyObject?) {
        if overlayDismisses == false {
            return
        }
        
        guard let recognizer = recognizer else { return }
        
        if recognizer.state == .began {
            if let overlayDismissHandler = overlayDismissHandler {
                if overlayDismissHandler() {
                    dismiss()
                }
            } else {
                dismiss()
            }
        }
    }
    
    // MARK: Subclass Hooks
    
    func willShowWithType(showType: PopupViewShowType) {}
    func didShowWithType(showType: PopupViewShowType) {}
    func willDismissWithType(dismissType: PopupViewDismissType) {}
    func didDismissWithType(dismissType: PopupViewDismissType) {}
}

extension PopupView: KeyboardHelperDelegate {
    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardWillShowWithState state: KeyboardState) {
        keyboardState = state
        if !automaticallyMovesWithKeyboard {
            return
        }
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        let keyboardHeight = keyboardState?.intersectionHeightForView(view: window) ?? 0
        
        UIView.animate(withDuration: 0.2) {
            self.dialogView.frame = self._dialogFrameWithKeyboardHeight(height: keyboardHeight)
        }
    }
    
    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardWillHideWithState state: KeyboardState) {
        if !automaticallyMovesWithKeyboard {
            return
        }
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        let keyboardHeight = keyboardState?.intersectionHeightForView(view: window) ?? 0
        
        UIView.animate(withDuration: 0.2) {
            self.dialogView.frame = self._dialogFrameWithKeyboardHeight(height: keyboardHeight)
        }
    }
    
    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardDidHideWithState state: KeyboardState) {
        if !automaticallyMovesWithKeyboard {
            return
        }
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        let keyboardHeight = keyboardState?.intersectionHeightForView(view: window) ?? 0
        
        UIView.animate(withDuration: 0.2) {
            self.dialogView.frame = self._dialogFrameWithKeyboardHeight(height: keyboardHeight)
        }
    }
    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardDidShowWithState state: KeyboardState) {
        
    }
}
