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
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(titleView)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        titleView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview().inset(10)
            $0.width.greaterThanOrEqualTo(130).priority(.medium)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                
            } else {
                
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                
            } else {
                
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleView.text = ""
    }
    
    func setData(data: DevicesResponseData) {
        self.data = data
        
        titleView.text = data.deviceName
    }
}
