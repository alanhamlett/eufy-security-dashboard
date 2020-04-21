//
//  File.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class LoginViewController: UIViewController {
    fileprivate var keyboardState: KeyboardState?
    fileprivate var bottomConstraint: Constraint!
    
    private let logo = UIImageView(image: UIImage(named: "goodbuy-logo-light"))
    
    private lazy var joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Join", for: .normal)
        button.titleLabel?.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var loginButton: RoundInterfaceButton = {
        let button = RoundInterfaceButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        button.setTitleColor(ColorManager.shared.secondaryColor, for: .normal)
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Access your account."
        label.font = UIFont.roundedFont(ofSize: .title3, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var usernameInput: UITextField = {
        let field = UITextField()
        field.backgroundColor = ColorManager.shared.secondaryColor
        field.textColor = .white
        field.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        field.returnKeyType = .next
        field.keyboardAppearance = .light
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textAlignment = .center
        field.tintColor = .white
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        field.attributedPlaceholder = NSAttributedString(string: "Username or Email", attributes: [NSAttributedString.Key.foregroundColor: Color.defaultColor.light().light(), NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        field.placeholder = "Username or Email"
        field.layer.cornerRadius = 10
        field.addTarget(self, action: #selector(changedScreenName), for: .editingChanged)
        return field
    }()
    
    private lazy var passwordInput: UITextField = {
        let field = UITextField()
        field.backgroundColor = ColorManager.shared.secondaryColor
        field.textColor = .white
        field.font = UIFont.roundedFont(ofSize: .headline, weight: .bold)
        field.returnKeyType = .send
        field.keyboardAppearance = .light
        field.keyboardType = .asciiCapable
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        field.textAlignment = .center
        field.tintColor = .white
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        field.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: Color.defaultColor.light().light(), NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        field.placeholder = "Password"
        field.layer.cornerRadius = 10
        return field
    }()
    
    override func viewDidLoad() {
        title = "Welcome"
        view.backgroundColor = Color.defaultColor
         
        view.addSubview(logo)
        logo.isHidden = true
        view.addSubview(joinButton)
        view.addSubview(loginButton)
        view.addSubview(titleLabel)
        view.addSubview(usernameInput)
        view.addSubview(passwordInput)
        
        usernameInput.delegate = self
        passwordInput.delegate = self
        
        joinButton.snp.makeConstraints {
            $0.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        logo.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(joinButton.snp.bottom).offset(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(logo.snp.bottom).offset(40)
            $0.width.equalTo(view).inset(40)
        }
        
        usernameInput.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(22)
            $0.centerX.equalTo(view)
            $0.height.equalTo(38)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        passwordInput.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(22)
            $0.centerX.equalTo(view)
            $0.height.equalTo(38)
            $0.top.equalTo(usernameInput.snp.bottom).offset(10)
        }
        
        loginButton.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(44)
            bottomConstraint = $0.bottom.equalTo(view).constraint
        }
        
        KeyboardHelper.defaultHelper.addDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernameInput.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func changedScreenName() {
//        let text = usernameInput.text
//        view.backgroundColor = Color.colorForText(text)
//        loginButton.setTitleColor(view.backgroundColor?.dark(), for: .normal)
//        usernameInput.backgroundColor = Color.colorForText(text).darkened(amount: 0.1)
//        passwordInput.backgroundColor = Color.colorForText(text).darkened(amount: 0.1)
    }
    
    @objc func loginPressed() {
        loginButton.loadingIndicator(true, color: ColorManager.shared.secondaryColor)
        loginButton.setTitle("", for: .normal)
        setUser()
    }
    
    private func setUser() {
        if let username = usernameInput.text, let password = passwordInput.text, username.count > 0, password.count > 0 {
            if UserManager.current.setUser(username: username, password: password) {
                UserManager.current.login { (completed) in
                    guard completed else {
                        print("Could not complete user login.")
                        return
                    }
                    DispatchQueue.main.async {
                        AppDelegate.shared.authContinue()
                    }
                }
            } else {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                
                loginButton.loadingIndicator(false)
                loginButton.setTitle("Login", for: .normal)
            }
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            loginButton.loadingIndicator(false)
            loginButton.setTitle("Login", for: .normal)
            
            let shakeAngle: CGFloat = 0.1
            let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
            animation.duration = 0.06
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.isRemovedOnCompletion = true
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.values = [NSValue(caTransform3D: CATransform3DMakeRotation(shakeAngle, 0.0, 0.0, 1.0)), NSValue(caTransform3D: CATransform3DMakeRotation(-shakeAngle, 0.0, 0.0, 1.0))]
            usernameInput.layer.add(animation, forKey: "input.shake")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let acceptableCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-"
//        let cs = CharacterSet(charactersIn: acceptableCharacters).inverted
//        let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
//        return (string == filtered)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setUser()
        return false
    }
}

extension LoginViewController: KeyboardHelperDelegate {
    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardWillShowWithState state: KeyboardState) {
        keyboardState = state
        self.updateViewConstraints()
        UIView.animate(withDuration: state.animationDuration) {
            self.bottomConstraint.update(offset: -state.intersectionHeightForView(view: self.view) - 16)
            self.view.layoutIfNeeded()
        }
    }

    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardWillHideWithState state: KeyboardState) {
        keyboardState = state
        self.updateViewConstraints()
        UIView.animate(withDuration: state.animationDuration) {
            self.bottomConstraint.update(offset: 0)
            self.view.layoutIfNeeded()
        }
    }

    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardDidHideWithState state: KeyboardState) {
        keyboardState = nil
    }
    
    func keyboardHelper(_ keyboardHelper: KeyboardHelper, keyboardDidShowWithState state: KeyboardState) {}
}
