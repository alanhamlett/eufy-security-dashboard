//
//  TitleBarView.swift
//  Goodbuy
//
//  Created by James Mudgett on 1/15/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit

protocol TitleBarViewDelegate {
    func tappedBack()
    func tappedSettings()
    func tappedInfo()
}

class TitleBarView: UIView {
    var delegate: TitleBarViewDelegate?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    let icon = UIImageView(image: UIImage(named: "pound")?.withRenderingMode(.alwaysTemplate))
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "hotline"
        label.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "info"), for: .normal)
        button.addTarget(self, action: #selector(tappedRightButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    var title: String?
    var subTitle: String?
    
    convenience init(title: String?, subTitle: String?) {
        self.init(frame: CGRect.zero)
        
        self.title = title
        self.subTitle = subTitle
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backButton)
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(rightButton)
        
        backButton.snp.makeConstraints {
            $0.left.equalTo(self).inset(5)
            $0.bottom.equalTo(self).inset(8)
            $0.width.height.equalTo(38)
        }
        
        icon.snp.makeConstraints {
            $0.left.equalTo(backButton.snp.right).offset(10)
            $0.centerY.equalTo(backButton)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(icon.snp.right).offset(8)
            $0.centerY.equalTo(backButton)
        }
        
        rightButton.snp.makeConstraints {
            $0.right.equalTo(self).inset(16)
            $0.bottom.equalTo(self).inset(8)
            $0.width.height.equalTo(38)
        }
        
        updateStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStyles() {
//        backgroundColor = Color.colorForText(data?.name)
//        icon.tintColor = Color.colorForText(data?.name).vibrant()
    }
    
    @objc func tappedBack() {
        delegate?.tappedBack()
    }
    
    @objc func tappedRightButton() {
//        if let data = data, data.isOwner {
//            delegate?.tappedSettings()
//        } else {
//            delegate?.tappedInfo()
//        }
    }
}
