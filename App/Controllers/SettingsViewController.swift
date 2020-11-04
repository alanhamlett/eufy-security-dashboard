//
//  SettingsViewController.swift
//  Eufy
//
//  Created by James Mudgett on 11/3/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
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
    
    override func viewDidLoad() {
        title = "Settings"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logOut))
        
        circularSlider.minimumValue = 1.0
        circularSlider.maximumValue = 121.0
        circularSlider.diskFillColor = .clear
        circularSlider.diskColor = .clear
        circularSlider.trackFillColor = .black
        circularSlider.backgroundColor = .clear
        circularSlider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)
        
        view.addSubview(circularSlider)
        view.addSubview(refreshLabel)
        
        circularSlider.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(300)
        }
        
        refreshLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStyles()
        
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
        refreshLabel.textColor = dark ? .white : .black
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
