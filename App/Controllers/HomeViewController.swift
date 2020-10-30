//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private var cameras: [DevicesResponseData] = []
    private var sensors: [DevicesResponseData] = []
    
    private func getDeviceData() {
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

            // distribute data to proper section
            for item in data {
                if let type = item.deviceType {
                    switch type {
                    case DeviceType.camera:
                        self?.cameras.append(item)
                    case DeviceType.door, DeviceType.motion:
                        self?.sensors.append(item)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        view.alwaysBounceVertical = true
        view.register(CameraViewCell.self, forCellWithReuseIdentifier: "CameraCell")
        view.register(SensorViewCell.self, forCellWithReuseIdentifier: "SensorCell")
        return view
    }()
    
    private var refreshTimer: Timer?
    
    override func viewDidLoad() {
        title = "Home"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logOut))
        
        refreshTimer?.invalidate()
        refreshTimer = Timer(timeInterval: 60.0, repeats: true) { [weak self](timer) in
            self?.getDeviceData()
            self?.collectionView.reloadData()
        }
        refreshTimer?.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        refreshTimer?.invalidate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func logOut() {
        DispatchQueue.main.async {
            AppDelegate.shared.logOut()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
//            (cell as? CameraViewCell)?.setData(data: data)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            let data = sensors[indexPath.row]
//            (cell as? SensorViewCell)?.setData(data: data)
            return cell
        }
    }


}
