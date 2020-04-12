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
        let messagesVC = UIViewController()
        let bidsVC = UIViewController()
        let accountVC = UIViewController()
        
        let homeNav = ColorAwareNavigationController(rootViewController: homeVC)
        let messagesNav = ColorAwareNavigationController(rootViewController: messagesVC)
        let bidsNav = ColorAwareNavigationController(rootViewController: bidsVC)
        let accountNav = ColorAwareNavigationController(rootViewController: accountVC)
        
        let homeBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "home-selected")?.withRenderingMode(.alwaysOriginal))
        let messagesBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "messages")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "messages-selected")?.withRenderingMode(.alwaysOriginal))
        let bidsBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "bids")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "bids-selected")?.withRenderingMode(.alwaysOriginal))
        let accountBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "account")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "account-selected")?.withRenderingMode(.alwaysOriginal))

        homeVC.tabBarItem = homeBarItem
        messagesVC.tabBarItem = messagesBarItem
        bidsVC.tabBarItem = bidsBarItem
        accountVC.tabBarItem = accountBarItem
        
        self.addChild(homeNav)
        self.addChild(messagesNav)
        self.addChild(bidsNav)
        self.addChild(accountNav)
    }
}

extension TabBarController: TabBarDelegate {
    func tapPost() {
        let camera = CameraViewController()
        camera.modalPresentationStyle = .pageSheet
        camera.isModalInPresentation = true
        self.present(camera, animated: true, completion: nil)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newListingButton)
        newListingButton.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bringSubviewToFront(newListingButton)
    }
    
    @objc func tapPost() {
        postDelegate?.tapPost()
    }
}
