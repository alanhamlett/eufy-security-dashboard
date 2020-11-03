//
//  SensorViewCell.swift
//  Debug
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

class SensorViewCell: UICollectionViewCell {
    private var data: DevicesResponseData?
    
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.font(ofSize: .title2, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(titleView)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        titleView.snp.makeConstraints {
            $0.top.bottom.right.equalTo(0)
            $0.left.equalTo(20)
            $0.width.equalTo(UIScreen.main.bounds.width / 4 - 16 * 2)
            $0.height.equalTo(60)
        }
        
        updateStyles()
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
        titleView.text = ""
        
        updateStyles()
    }
    
    func updateStyles() {
        let dark = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        titleView.textColor = dark ? .white : .black
        contentView.backgroundColor = dark ? UIColor(white: 0.1, alpha: 1) : UIColor(white: 0.98, alpha: 1)
    }
    
    func setData(data: DevicesResponseData) {
        self.data = data
        
        titleView.text = data.deviceName
    }
}
