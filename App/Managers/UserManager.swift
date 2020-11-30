//
//  UserManager.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

let UserKeychainEmailKey = "Email"
let UserKeychainPassKey = "Password"

struct TokenData: Decodable {
    let id: Int
    let token: String
    let userID: Int
}

class UserManager: NSObject {
    static let current = UserManager()
    
    var password: String? {
        get {
            return KeychainWrapper.standard.string(forKey: UserKeychainPassKey)
        }
    }
    
    var accessToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: BearerKeychainNameKey)
        }
    }
    
    var email: String? {
        get {
            return KeychainWrapper.standard.string(forKey: UserKeychainEmailKey)
        }
    }
    
    var userId: Int? = nil
    
    override init() {
        super.init()
        
        login { (completed) in
            if completed == false {
                DispatchQueue.main.async {
                    AppDelegate.shared.logOut()
                }
            }
        }
    }
    
    func setUser(email: String, password: String) -> Bool {
        return KeychainWrapper.standard.set(email, forKey: UserKeychainEmailKey) &&
            KeychainWrapper.standard.set(password, forKey: UserKeychainPassKey)
    }
    
    func reset() {
        _ = KeychainWrapper.standard.removeObject(forKey: UserKeychainEmailKey)
        _ = KeychainWrapper.standard.removeObject(forKey: UserKeychainPassKey)
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        guard let email = email, let password = password else {
            completion(false)
            return
        }
        UserAPIClient.login(email: email, password: password) { result in
            completion(result != nil)
        }
    }
}
