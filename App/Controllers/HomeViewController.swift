//
//  HomeViewController.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private var cameras: [DevicesResponseData] = []
    private var sensors: [DevicesResponseData] = []
    
    @objc func getDeviceData() {
        UserAPIClient.devices { [weak self](response) in
            // API returns banned when access token is expired.
            guard let response = response, response.banned == nil else {
                // Trys to login again, if that fails then return to login screen.
                UserManager.current.login { [weak self](completed) in
                    guard completed else {
                        self?.logOut()
                        return
                    }
                }
                return
            }

            guard let data = response.data else { return } // should probably print that no devices were loaded.

            self?.cameras = []
            self?.sensors = []
            
            // distribute data to proper section
            for item in data {
                if let type = item.type {
                    switch type {
                    case DeviceType.camera:
                        self?.cameras.append(item)
                    case DeviceType.door:
                        self?.sensors.append(item)
                    case DeviceType.motion:
                        break
                    default:
                        break
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        view.alwaysBounceVertical = true
        view.register(CameraViewCell.self, forCellWithReuseIdentifier: "CameraCell")
        view.register(SensorViewCell.self, forCellWithReuseIdentifier: "SensorCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private var refreshTimer = Timer()
    
    override func viewDidLoad() {
        title = "Home"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settings))
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        getDeviceData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var refreshTime = 60
        if UserDefaults.standard.bool(forKey: "customRefresh") {
            refreshTime = UserDefaults.standard.integer(forKey: "refreshTime")
        }
        
        refreshTimer.invalidate()
        refreshTimer = Timer.scheduledTimer(timeInterval: Double(refreshTime), target: self, selector: #selector(getDeviceData), userInfo: nil, repeats: true)
        
        updateStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        refreshTimer.invalidate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func logOut() {
        DispatchQueue.main.async {
            AppDelegate.shared.logOut()
        }
    }
    
    @objc func settings() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateCollectionLayout()
        updateStyles()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionLayout()
    }
    
    private func updateCollectionLayout() {
        collectionView.reloadData()
    }
    
    private func updateStyles() {
        let dark = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        collectionView.backgroundColor = dark ? .black : .white
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? cameras.count : sensors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath)
            let data = cameras[indexPath.row]
            (cell as? CameraViewCell)?.setData(device: data)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SensorCell", for: indexPath)
            let data = sensors[indexPath.row]
            (cell as? SensorViewCell)?.setData(device: data)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 1 ? UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0) : .zero
    }
}
