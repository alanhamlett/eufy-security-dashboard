//
//  SettingsViewController.swift
//
//  Created by James Mudgett on 11/3/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import HGCircularSlider

class SettingsViewController: UIViewController {
    
    let circularSlider = CircularSlider()
    private lazy var refreshLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.font(ofSize: .title1, weight: .semibold)
        return label
    }()
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.font(ofSize: .headline, weight: .regular)
        return label
    }()
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.font(ofSize: .subheadline, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        title = "Settings"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logOut))
        
        circularSlider.minimumValue = 1.0
        circularSlider.maximumValue = 121.0
        circularSlider.diskFillColor = .clear
        circularSlider.diskColor = .clear
        circularSlider.trackFillColor = .black
        circularSlider.lineWidth = 22
        circularSlider.backtrackLineWidth = 22
        circularSlider.thumbRadius = 22
        circularSlider.backgroundColor = .clear
        circularSlider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)
        
        view.addSubview(circularSlider)
        view.addSubview(refreshLabel)
        view.addSubview(userLabel)
        view.addSubview(versionLabel)
        
        circularSlider.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(400)
        }
        
        refreshLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        userLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(circularSlider.snp.bottom).offset(50)
        }
        
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userLabel.snp.bottom).offset(10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStyles()
        
        userLabel.text = UserManager.current.email
        versionLabel.text = "Version \(AppDelegate.shared.appVersion)"
        
        var refreshTime = 60
        if UserDefaults.standard.bool(forKey: "customRefresh") {
            refreshTime = UserDefaults.standard.integer(forKey: "refreshTime")
        }
        
        circularSlider.endPointValue = CGFloat(refreshTime)
        updateRefreshLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func updateStyles() {
        let dark = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        view.backgroundColor = dark ? .black : .white
        circularSlider.trackFillColor = dark ? .white : .black
        circularSlider.trackColor = dark ? UIColor(white: 1, alpha: 0.3) : UIColor(white: 0, alpha: 0.3)
        refreshLabel.textColor = dark ? .white : .black
        userLabel.textColor = dark ? UIColor(white: 1, alpha: 0.5) : UIColor(white: 0, alpha: 0.5)
        versionLabel.textColor = dark ? UIColor(white: 1, alpha: 0.5) : UIColor(white: 0, alpha: 0.5)
    }
    
    @objc func logOut() {
        DispatchQueue.main.async {
            AppDelegate.shared.logOut()
        }
    }
    
    @objc func changeSlider() {
        updateRefreshLabel()
        UserDefaults.standard.setValue(true, forKey: "customRefresh")
        UserDefaults.standard.setValue(Int(circularSlider.endPointValue), forKey: "refreshTime")
    }
    
    private func updateRefreshLabel() {
        refreshLabel.text = "\(Int(circularSlider.endPointValue)) sec refresh"
    }
}
