//
//  SearchBarView.swift
//  Hotline
//
//  Created by James Mudgett on 1/15/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit

protocol SearchBarViewDelegate {
    func tappedSettings()
    func search(text: String?)
}

class SearchBarView: UIView {
    var delegate: SearchBarViewDelegate?
    
    var searchbarLeftView = UIImageView(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate))
    
    lazy var searchbarRightView: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "search_clear"), for: .normal)
        button.addTarget(self, action: #selector(tappedClear), for: .touchUpInside)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    
    private lazy var searchBar: UITextField = {
        var searchIconFrame = searchbarLeftView.frame
        searchIconFrame.size.width = 44
        searchbarLeftView.frame = searchIconFrame
        
        let field = UITextField()
        field.backgroundColor = ColorManager.shared.secondaryColor
        field.textColor = .white
        field.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        field.returnKeyType = .search
        field.keyboardAppearance = .light
        field.keyboardType = .asciiCapable
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .left
        field.tintColor = .white
        field.leftView = searchbarLeftView
        field.leftViewMode = .always
        field.rightView = searchbarRightView
        field.rightViewMode = .always
        field.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.layer.cornerRadius = 10
        field.addTarget(self, action: #selector(changedSearch), for: .editingChanged)
        return field
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.addTarget(self, action: #selector(tappedSettings), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var inSearchMode = false {
        didSet(value) {
            searchBarConstraint()
            settingsButton.isHidden = !value
            cancelButton.isHidden = value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(searchBar)
        addSubview(settingsButton)
        addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints {
            $0.right.equalTo(self).inset(14)
            $0.centerY.equalTo(searchBar)
        }
        
        settingsButton.snp.makeConstraints {
            $0.right.equalTo(self).inset(16)
            $0.centerY.equalTo(searchBar)
            $0.width.height.equalTo(38)
        }
        
        searchBarConstraint()
        
        updateStyles()
        
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func searchBarConstraint() {
        if inSearchMode {
            searchBar.snp.remakeConstraints {
                $0.left.equalTo(self).inset(12)
                $0.right.equalTo(cancelButton.snp.left).offset(-12)
                $0.height.equalTo(38)
                $0.bottom.equalTo(self).inset(8)
            }
        } else {
            searchBar.snp.remakeConstraints {
                $0.left.equalTo(self).inset(12)
                $0.right.equalTo(settingsButton.snp.left).offset(-12)
                $0.height.equalTo(38)
                $0.bottom.equalTo(self).inset(8)
            }
        }
    }
    
    func updateStyles() {
        backgroundColor = ColorManager.shared.defaultColor
        searchbarLeftView.tintColor = ColorManager.shared.defaultColor
        searchBar.backgroundColor = ColorManager.shared.secondaryColor
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: ColorManager.shared.defaultColor.light().light()])
    }
    
    @objc func changedSearch() {
        if let text = searchBar.text, text.count > 0 {
            searchbarRightView.isHidden = false
            delegate?.search(text: text)
        } else {
            searchbarRightView.isHidden = true
        }
    }
    
    @objc func tappedClear() {
        searchBar.text = ""
        searchbarRightView.isHidden = true
        delegate?.search(text: nil)
    }
    
    @objc func tappedSettings() {
        delegate?.tappedSettings()
    }
    
    @objc func tappedCancel() {
        searchBar.resignFirstResponder()
        tappedClear()
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inSearchMode = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inSearchMode = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
