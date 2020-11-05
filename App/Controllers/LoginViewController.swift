//
//  LoginViewController.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class LoginViewController: UIViewController {
    fileprivate var bottomConstraint: Constraint!
    
    private lazy var loginButton: RoundInterfaceButton = {
        let button = RoundInterfaceButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Access your account."
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailInput: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.textColor = .black
        field.returnKeyType = .next
        field.keyboardAppearance = .light
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.tintColor = .white
        field.placeholder = "Email"
        field.text = UserManager.current.name
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        field.leftViewMode = .always
        return field
    }()
    
    private lazy var passwordInput: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.textColor = .black
        field.returnKeyType = .send
        field.keyboardAppearance = .light
        field.keyboardType = .asciiCapable
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        field.tintColor = .white
        field.placeholder = "Password"
        field.text = UserManager.current.password
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        field.leftViewMode = .always
        return field
    }()
    
    override func viewDidLoad() {
        title = "Welcome"
        view.backgroundColor = .white
        
        view.addSubview(loginButton)
        view.addSubview(titleLabel)
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        
        emailInput.delegate = self
        passwordInput.delegate = self
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
            $0.width.equalToSuperview().inset(40)
        }
        
        emailInput.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(22)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(38)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        passwordInput.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(22)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(38)
            $0.top.equalTo(emailInput.snp.bottom).offset(10)
        }
        
        loginButton.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(44)
            $0.top.equalTo(passwordInput.snp.bottom).offset(10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailInput.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func loginPressed() {
        loginButton.setTitle("", for: .normal)
        setUser()
    }
    
    private func setUser() {
        if let email = emailInput.text, let password = passwordInput.text, email.count > 0, password.count > 0 {
            if UserManager.current.setUser(email: email, password: password) {
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
            emailInput.layer.add(animation, forKey: "input.shake")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setUser()
        return false
    }
}
