//
//  AppDelegate.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import UIKit
import Foundation

var CurrentUser: UserManager {
    get {
        return UserManager.current
    }
}

var KeyWindow: UIWindow? {
    get {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}

class ColorAwareNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared = AppDelegate()
    
    var window: UIWindow?
    
    var appVersion: String {
        get { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String }
    }
    
    var appBuild: String {
        get { Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
        AppDelegate.shared.window?.backgroundColor = .black
        
        if UserManager.current.name != nil {
            authContinue()
        } else {
            authUser()
        }
        
        AppDelegate.shared.window?.makeKeyAndVisible()
        
        return true
    }
    
    func authContinue() {
        AppDelegate.shared.window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
    }
    
    func authUser() {
        AppDelegate.shared.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
    func logOut() {
        authUser()
    }
}

