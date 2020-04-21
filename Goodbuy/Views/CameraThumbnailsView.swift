//
//  CameraThumbnailsView.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/14/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

class CameraThumbnailsView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = CGSize(width: 54, height: 54)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = false
        alwaysBounceHorizontal = true
        register(CameraThumbnailCell.self, forCellWithReuseIdentifier: "Cell")
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        if let recordings = recordingsForFilterMode(filterMode) {
//            let data = recordings[indexPath.row]
//            (cell as? RecordingGridCell)?.setData(data: data)
//        }
        cell.prepareForReuse()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

class CameraThumbnailCell: UICollectionViewCell {
    var thumbnail = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.layer.cornerRadius = 8
        thumbnail.layer.masksToBounds = true
        thumbnail.backgroundColor = UIColor(white: 1, alpha: 0.5)
        contentView.addSubview(thumbnail)
        
        thumbnail.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        contentView.snp.makeConstraints { make in
            make.size.equalTo(54)
        }
        
        debugPrint("cell started")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                thumbnail.alpha = 0.6
            } else {
                thumbnail.alpha = 1
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                thumbnail.alpha = 0.6
            } else {
                thumbnail.alpha = 1
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
    }
}


