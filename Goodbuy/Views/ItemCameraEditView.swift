//
//  ItemCameraEditView.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import pop

class ItemCameraEditView: UIView {
    fileprivate let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    lazy var imageContainer: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hex: 0xDFDFDF)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    fileprivate lazy var titleField: UITextField = {
        let label = UITextField()
        label.attributedPlaceholder = NSAttributedString(string: "Item title", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x959595)])
        label.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        label.textColor = .black
        label.tintColor = ColorManager.shared.blue
        label.textAlignment = .left
        label.returnKeyType = .done
        label.delegate = self
        return label
    }()
    
    var title: String? {
        get {
            return titleField.text
        }
        set(value) {
            titleField.text = value
        }
    }
    
    fileprivate lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(tappedEdit), for: .touchUpInside)
        button.titleLabel?.font = UIFont.roundedFont(ofSize: .subheadline, weight: .medium)
        button.setTitleColor(UIColor(hex: 0x959595), for: .normal)
        button.tintColor = UIColor(hex: 0x959595)
        return button
    }()
    
    fileprivate lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(tappedDone), for: .touchUpInside)
        button.titleLabel?.font = UIFont.roundedFont(ofSize: .subheadline, weight: .medium)
        button.setTitleColor(UIColor(hex: 0x959595), for: .normal)
        button.tintColor = UIColor(hex: 0x959595)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 6
        
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        blurView.contentView.backgroundColor = UIColor.white
        blurView.layer.masksToBounds = true
        
        addSubview(imageContainer)
        addSubview(titleField)
        addSubview(editButton)
        addSubview(doneButton)
        
        imageContainer.snp.makeConstraints {
            $0.top.bottom.equalTo(self).inset(8)
            $0.left.equalTo(20)
            $0.size.equalTo(44)
        }
        
        titleField.snp.makeConstraints {
            $0.left.equalTo(imageContainer.snp.right).offset(14)
            $0.right.equalTo(doneButton.snp.left).inset(-10)
            $0.centerY.equalTo(imageContainer)
        }
        
        editButton.snp.makeConstraints {
            $0.right.equalTo(self).inset(26)
            $0.centerY.equalTo(imageContainer)
        }
        
        doneButton.snp.makeConstraints {
            $0.right.equalTo(self).inset(26)
            $0.centerY.equalTo(imageContainer)
        }
        
        doneButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let roundPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        blurView.layer.mask = maskLayer
    }
    
    @objc func tappedEdit() {
        titleField.becomeFirstResponder()
        editButton.isHidden = true
        doneButton.isHidden = false
        
        titleField.selectAll(nil)
    }
    
    @objc func tappedDone() {
        titleField.resignFirstResponder()
        editButton.isHidden = false
        doneButton.isHidden = true
    }
}

extension ItemCameraEditView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editButton.isHidden = true
        doneButton.isHidden = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tappedDone()
        return true
    }
}
