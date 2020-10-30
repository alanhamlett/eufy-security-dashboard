//
//  CameraViewCell.swift
//  Debug
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CameraViewCell: UICollectionViewCell {
    private var data: DevicesResponseData?
    
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    private lazy var thumbnail: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 4
        image.layer.masksToBounds = true
        image.backgroundColor = .black
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(titleView)
        contentView.addSubview(thumbnail)
        
        thumbnail.snp.makeConstraints {
            $0.top.left.right.equalTo(0)
            $0.width.equalTo(300)
            $0.height.equalTo(200)
        }
        
        titleView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(thumbnail.snp.bottom)
            $0.bottom.equalTo(0)
        }
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
        titleView.text = ""
    }
    
    func setData(data: DevicesResponseData) {
        self.data = data
        
        titleView.text = data.deviceName
        
        guard let thumbnailUrl = data.thumbnail else { return }
        
        let url = URL(string: thumbnailUrl)
        thumbnail.kf.indicatorType = .activity
        thumbnail.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                })
        
//        if image.size.width > image.size.height {
//            thumbnail.snp.remakeConstraints { make in
//                make.width.equalTo(148)
//                make.height.equalTo(90)
//                make.top.left.right.equalTo(0)
//            }
//        } else {
//            thumbnail.snp.remakeConstraints { make in
//                make.width.equalTo(90)
//                make.height.equalTo(148)
//                make.top.left.right.equalTo(0)
//            }
//        }
    }
}