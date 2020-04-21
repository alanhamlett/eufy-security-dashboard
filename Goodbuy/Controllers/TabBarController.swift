//
//  TabBarController.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/11/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    lazy var customTabBar: TabBar = {
        let tb = TabBar()
        return tb
    }()
    
    override open var tabBar: UITabBar {
        get {
            return customTabBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setValue(customTabBar, forKey: "tabBar")
        
        (tabBar as? TabBar)?.postDelegate = self
        
        let homeVC = HomeViewController()
        let messagesVC = MessagesViewController()
        let bidsVC = BidsViewController()
        let accountVC = AccountViewController()
        
        let homeNav = ColorAwareNavigationController(rootViewController: homeVC)
        let messagesNav = ColorAwareNavigationController(rootViewController: messagesVC)
        let bidsNav = ColorAwareNavigationController(rootViewController: bidsVC)
        let accountNav = ColorAwareNavigationController(rootViewController: accountVC)
        
        let homeBarItem = UITabBarItem(title: "", image: UIImage.init(named: "home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "home-selected")?.withRenderingMode(.alwaysOriginal))
        let messagesBarItem = UITabBarItem(title: "", image: UIImage.init(named: "messages")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "messages-selected")?.withRenderingMode(.alwaysOriginal))
        let bidsBarItem = UITabBarItem(title: "", image: UIImage.init(named: "bids")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "bids-selected")?.withRenderingMode(.alwaysOriginal))
        let accountBarItem = UITabBarItem(title: "", image: UIImage.init(named: "account")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "account-selected")?.withRenderingMode(.alwaysOriginal))

        homeVC.tabBarItem = homeBarItem
        messagesVC.tabBarItem = messagesBarItem
        bidsVC.tabBarItem = bidsBarItem
        accountVC.tabBarItem = accountBarItem
        
        viewControllers = [homeNav, messagesNav, bidsNav, accountNav]
        selectedIndex = 0
    }
}

extension TabBarController: TabBarDelegate {
    func tapPost() {
        let camera = CameraViewController()
        camera.modalPresentationStyle = .pageSheet
        self.present(ColorAwareNavigationController(rootViewController: camera), animated: true, completion: nil)
    }
}

protocol TabBarDelegate {
    func tapPost()
}

class TabBar: UITabBar {
    var postDelegate: TabBarDelegate?
    
    lazy private var newListingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.setImage(UIImage(named: "camera-selected"), for: .highlighted)
        button.addTarget(self, action: #selector(tapPost), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var itemsBadge: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.roundedFont(ofSize: .caption1, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = ColorManager.shared.accentColor
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 4
        label.layer.cornerRadius = 8.5
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newListingButton)
        newListingButton.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(5)
        }
        
        addSubview(itemsBadge)
        itemsBadge.snp.makeConstraints {
            $0.right.equalTo(newListingButton.snp.right).inset(-6)
            $0.top.equalTo(newListingButton.snp.top).inset(-4)
            $0.height.equalTo(17)
            $0.width.greaterThanOrEqualTo(17)
        }
        
        backgroundColor = .white
        barTintColor = .white
        
        itemsBadge.text = "3"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewForTabBarButtonIndex(_ index: Int) -> UIView? {
        var items: [UIView] = []
        for view in subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                items.append(view)
            }
        }
        
        if index > items.count - 1 {
            return nil
        }
        
        items = items.sorted { (view1, view2) -> Bool in
            return view1.frame.origin.x < view2.frame.origin.x
        }
        
        return items[index]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonX = frame.size.width / 5
        viewForTabBarButtonIndex(0)?.frame = CGRect.init(x: 0, y: 0, width: buttonX, height: 44)
        viewForTabBarButtonIndex(1)?.frame = CGRect.init(x: buttonX, y: 0, width: buttonX, height: 44)
        viewForTabBarButtonIndex(2)?.frame = CGRect.init(x: buttonX * 3, y: 0, width: buttonX, height: 44)
        viewForTabBarButtonIndex(3)?.frame = CGRect.init(x: buttonX * 4, y: 0, width: buttonX, height: 44)
        bringSubviewToFront(newListingButton)
        bringSubviewToFront(itemsBadge)
    }
    
    @objc func tapPost() {
        postDelegate?.tapPost()
    }
}
