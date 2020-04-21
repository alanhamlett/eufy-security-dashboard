//
//  AccountViewController.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import SnapKit

class AccountViewController: UIViewController, UIGestureRecognizerDelegate {
    fileprivate var keyboardState: KeyboardState?
    fileprivate var bottomConstraint: Constraint!
    
    fileprivate lazy var titleBar: TitleBarView = {
        let view = TitleBarView(title: "Account", subTitle: nil)
        view.backButton.isHidden = true
        view.rightButton.setImage(UIImage(named: "settings"), for: .normal)
        return view
    }()
    fileprivate var titleBarTopConstraint: Constraint!
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        title = ""
        
        let window = KeyWindow
        let height = window?.safeAreaInsets.top ?? 0.0
        
        view.addSubview(titleBar)
        
        titleBar.delegate = self
        titleBar.snp.makeConstraints {
            titleBarTopConstraint = $0.top.equalTo(0).constraint
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).priority(.medium)
            $0.height.equalTo(BarHeight + height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        titleBar.updateStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        // TODO: need to find a way to add/remove keyboard observer without causing strange animation transition on presentation.
        KeyboardHelper.defaultHelper.addDelegate(delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension AccountViewController: TitleBarViewDelegate {
    func tappedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func tappedRightButton() {
        let popup = AlertPopupView(image: nil, title: CurrentUser.name ?? "", message: "You're the best.")
        popup.addButton(title: "Close") { () -> PopupViewDismissType in
            return .flyDown
        }
        popup.addDefaultButton(title: "Log Out") { () -> PopupViewDismissType in
            AppDelegate.shared.logOut()
            return .noAnimation
        }
        popup.dialogButtonBackgroundColor = ColorManager.shared.defaultColor.light().light()
        popup.dialogButtonTextColor = ColorManager.shared.secondaryColor
        popup.dialogButtonDefaultTextColor = .white
        popup.dialogButtonDefaultBackgroundColor = ColorManager.shared.defaultColor
        popup.overlayDismisses = true
        popup.showWithType(showType: .normal)
    }
}

extension AccountViewController: KeyboardHelperDelegate {
    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardWillShowWithState state: KeyboardState) {
        
    }

    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardWillHideWithState state: KeyboardState) {
        
    }

    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardDidHideWithState state: KeyboardState) {
        keyboardState = nil
    }

    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardDidShowWithState state: KeyboardState) {
        
    }
}

