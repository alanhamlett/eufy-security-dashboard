//
//  CameraViewCell.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CameraViewCell: UICollectionViewCell {
    private var device: DevicesResponseData?
    
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
            $0.top.left.right.equalTo(0).priority(.medium)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 16).priority(.required)
            $0.height.equalTo(UIScreen.main.bounds.height / 2.5).priority(.required)
        }
        
        titleView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
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
    
    func setData(device: DevicesResponseData) {
        self.device = device
        
        titleView.text = device.name
        
        guard let thumbnailUrl = ThumbnailManager.shared[device] else { return }
        
        let url = URL(string: thumbnailUrl)
        thumbnail.kf.indicatorType = .activity
        thumbnail.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.1)),
                .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(_):
                        // print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        break
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                    self.layoutIfNeeded()
                })
        
        thumbnail.snp.remakeConstraints {
            $0.top.left.right.equalTo(0).priority(.medium)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 - 16).priority(.required)
            $0.height.equalTo(UIScreen.main.bounds.height / 2.5).priority(.required)
        }
    }
}
