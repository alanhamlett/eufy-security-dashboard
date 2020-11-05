//
//  UserManager.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

let UserKeychainNameKey = "Email"
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
    
    var name: String? {
        get {
            return KeychainWrapper.standard.string(forKey: UserKeychainNameKey)
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
        return KeychainWrapper.standard.set(email, forKey: UserKeychainNameKey) &&
            KeychainWrapper.standard.set(password, forKey: UserKeychainPassKey)
    }
    
    func reset() {
        _ = KeychainWrapper.standard.removeObject(forKey: UserKeychainNameKey)
        _ = KeychainWrapper.standard.removeObject(forKey: UserKeychainPassKey)
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        guard let email = KeychainWrapper.standard.string(forKey: UserKeychainNameKey), let password = KeychainWrapper.standard.string(forKey: UserKeychainPassKey) else {
            completion(false)
            return
        }
        
        UserAPIClient.login(email: email, password: password) { result in
            completion(result != nil)
        }
    }
}
