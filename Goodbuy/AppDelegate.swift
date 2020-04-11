//
//  AppDelegate.swift
//  Hotline
//
//  Created by James Mudgett on 10/24/19.
//  Copyright © 2019 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

let NextLevelAlbumTitle = "NextLevel"
let BarHeight: CGFloat = 54.0

var UserColor: UIColor {
    get {
        return ColorManager.shared.userColor
    }
}

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

var Color: ColorManager {
    get {
        return ColorManager.shared
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared = AppDelegate()
    
    var window: UIWindow?
    lazy var homeViewController: HomeViewController = {
        return HomeViewController()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(
            inMemoryIdentifier: "goodbuy-data",
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                
            }
        )
        Realm.Configuration.defaultConfiguration = config
        
        KeyboardHelper.defaultHelper.startObserving()
        
        AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
        AppDelegate.shared.window?.backgroundColor = .black
        
        if UserManager.current.name != nil {
            authContinue()
        } else {
            let vc = LoginViewController()
            let nc = ColorAwareNavigationController(rootViewController: vc)
            AppDelegate.shared.window?.rootViewController = nc
        }
        
        AppDelegate.shared.window?.makeKeyAndVisible()
        
        return true
    }
    
    func authContinue() {
        let nc = ColorAwareNavigationController(rootViewController: homeViewController)
        AppDelegate.shared.window?.rootViewController = nc
    }
    
    func logOut() {
        UserManager.current.reset()
        let vc = LoginViewController()
        let nc = ColorAwareNavigationController(rootViewController: vc)
        AppDelegate.shared.window?.rootViewController = nc
    }
}

class ColorAwareNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

