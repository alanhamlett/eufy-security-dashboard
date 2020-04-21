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
    func tappedRightButton()
}

class TitleBarView: UIView {
    var delegate: TitleBarViewDelegate?
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "hotline"
        label.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "info"), for: .normal)
        button.addTarget(self, action: #selector(tappedRightButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    var title: String?
    var subTitle: String?
    
    private var line = UIView()
    
    convenience init(title: String?, subTitle: String?) {
        self.init(frame: CGRect.zero)
        
        self.title = title
        self.subTitle = subTitle
        
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(line)
        
        backButton.snp.makeConstraints {
            $0.left.equalTo(self).inset(5)
            $0.bottom.equalTo(self).inset(8)
            $0.width.height.equalTo(38)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(backButton)
        }
        
        rightButton.snp.makeConstraints {
            $0.right.equalTo(self).inset(16)
            $0.bottom.equalTo(self).inset(8)
            $0.width.height.equalTo(38)
        }
        
        line.snp.makeConstraints {
            $0.left.right.equalTo(self)
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(self)
        }
        
        updateStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStyles(light: Bool? = false) {
        if light ?? false {
            backgroundColor = ColorManager.shared.defaultColor
        } else {
            backgroundColor = .white
            rightButton.tintColor = UIColor(hex: 0x9C9C9C)
            backButton.tintColor = UIColor(hex: 0x9C9C9C)
            titleLabel.textColor = .black
            line.backgroundColor = UIColor(hex: 0xD8D8D8)
        }
    }
    
    @objc func tappedBack() {
        delegate?.tappedBack()
    }
    
    @objc func tappedRightButton() {
        delegate?.tappedRightButton()
    }
}
