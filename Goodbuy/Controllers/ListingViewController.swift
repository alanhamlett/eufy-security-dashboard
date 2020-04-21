//
//  ListingViewController.swift
//  Goodbuy
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import SnapKit

class ListingViewController: UIViewController, UIGestureRecognizerDelegate {
    fileprivate var keyboardState: KeyboardState?
    fileprivate var bottomConstraint: Constraint!
    
    fileprivate lazy var titleBar: TitleBarView = {
        return TitleBarView(title: "Listing", subTitle: "5 miles")
    }()
    fileprivate var titleBarTopConstraint: Constraint!
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    fileprivate var data: Listing?
    
    convenience init(listing: Listing) {
        self.init()
        data = listing
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        view.backgroundColor = Color.colorForText(data?.title).dark()
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

extension ListingViewController: TitleBarViewDelegate {
    func tappedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func tappedRightButton() {
        
    }
}

extension ListingViewController: KeyboardHelperDelegate {
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
