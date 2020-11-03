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
        label.font = UIFont.font(ofSize: .title1, weight: .semibold)
        return label
    }()
    
    private lazy var thumbnail: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 5
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
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 16)
            $0.height.equalTo(UIScreen.main.bounds.height / 2.5)
        }
        
        titleView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(thumbnail.snp.bottom)
            $0.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
        }
    }
    
    override var isSelected: Bool {
        didSet {
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
        titleView.text = ""
        
        updateStyles()
    }
    
    func updateStyles() {
        let dark = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        titleView.textColor = dark ? .white : .black
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
                .transition(.none),
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
        
        thumbnail.snp.remakeConstraints {
            $0.top.left.right.equalTo(0)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 16)
            $0.height.equalTo(UIScreen.main.bounds.height / 2.5)
        }
    }
}
