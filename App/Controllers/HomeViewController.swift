//
//  HomeViewController.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import UIKit
import SnapKit
import Toaster

class HomeViewController: UIViewController {
    
    private var cameras: [DevicesResponseData] = []
    private var sensors: [DevicesResponseData] = []
    private var retries: Int = 0

    private let maxRetries = 2
    
    @objc func getDeviceData() {
        UserAPIClient.devices { [weak self](response) in
            guard let self = self else { return }
            
            // API returns banned when access token is expired.
            guard
                let response = response,
                let data = response.data,
                response.banned == nil
            else {
                // Trys to login again, if that fails then return to login screen.
                UserManager.current.login { [weak self](completed) in
                    guard let self = self else { return }
                    guard completed else {
                        if self.retries > self.maxRetries {
                            ToastCenter.default.currentToast?.cancel()
                            let toast = Toast(text: "Lost connection to Eufy servers and timed out.")
                            toast.show()
                            
                            self.retries = 0
                            self.logOut()
                            return
                        }
                        self.retries += 1
                        return
                    }
                }
                return
            }

            self.cameras = []
            self.sensors = []
            
            // distribute data to proper section
            for item in data {
                if let type = item.type {
                    switch type {
                    case .camera,
                         .floodlight,
                         .camera_e,
                         .doorbell,
                         .battery_doorbell,
                         .camera_2c,
                         .camera_2,
                         .camera_2_pro,
                         .camera_2c_pro,
                         .battery_doorbell_2,
                         .indoor_camera,
                         .solo_camera,
                         .solo_camera_pro,
                         .indoor_camera_1080,
                         .indoor_pt_camera,
                         .indoor_pt_camera_1080,
                         .solo_camera_spotlight_1080,
                         .solo_camera_spotlight_2k,
                         .solo_camera_spotlight_solar:
                        self.cameras.append(item)
                    case .door:
                        self.sensors.append(item)
                    case .station,
                         .motion,
                         .keypad,
                         .lock_basic,
                         .lock_advanced,
                         .lock_basic_no_finger,
                         .lock_advanced_no_finger:
                        // devices that don't support open/closed state nor camera thumbnail
                        break
                    case DeviceType.other:
                        break
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.errorLabel.isHidden = !(self.cameras.count == 0 && self.sensors.count == 0)
                self.collectionView.reloadData()
            }
        }
    }
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0.4, alpha: 1)
        label.text = "No supported cameras nor door sensors found."
        label.isHidden = true
        return label
    }()
    
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
        title = "Home" // TODO: support multiple base stations and use station name instead of hard-coding
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settings))
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
        return section == 1 ? UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0) : .zero
    }
}
