//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
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
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 60, left: 16, bottom: 0, right: 16)
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        view.alwaysBounceVertical = true
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CameraCell")
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SensorCell")
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
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath)
//            if let recordings = recordingsForFilterMode(filterMode) {
//                let data = recordings[indexPath.row]
//                (cell as? RecordingGridCell)?.setData(data: data)
//            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//            if let recordings = recordingsForFilterMode(filterMode) {
//                let data = recordings[indexPath.row]
//                (cell as? RecordingGridCell)?.setData(data: data)
//            }
            return cell
        }
    }


}
