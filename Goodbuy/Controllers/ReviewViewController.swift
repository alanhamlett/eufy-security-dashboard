//
//  ReviewViewController.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/20/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ReviewViewController: UIViewController, UIGestureRecognizerDelegate {
    fileprivate var keyboardState: KeyboardState?
    fileprivate var bottomConstraint: Constraint!
    
    fileprivate lazy var titleBar: TitleBarView = {
        let view = TitleBarView(title: "Review", subTitle: nil)
        view.backButton.isHidden = false
        view.rightButton.isHidden = false
        view.rightButton.setImage(UIImage(named: "camera-right"), for: .normal)
        view.updateStyles(light: true)
        return view
    }()
    fileprivate var titleBarTopConstraint: Constraint!
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        title = ""
        
        view.addSubview(titleBar)
        
        titleBar.delegate = self
        titleBar.snp.makeConstraints {
            titleBarTopConstraint = $0.top.equalTo(0).constraint
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).priority(.medium)
            $0.height.equalTo(55)
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

extension ReviewViewController: TitleBarViewDelegate {
    func tappedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func tappedRightButton() {
        
    }
}

extension ReviewViewController: KeyboardHelperDelegate {
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
