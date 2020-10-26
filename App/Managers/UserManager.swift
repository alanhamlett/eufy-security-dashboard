//
//  UserManager.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

let UserKeychainIDKey = "GoodbuyID"
let UserKeychainNameKey = "GoodbuyUsername"
let UserKeychainPassKey = "GoodbuyUserPassword"

struct LoginData: Codable {
    let username: String?
    let password: String?
}

class UserManager: NSObject {
    static let current = UserManager()
    
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
    
    func setUser(username: String, password: String) -> Bool {
        return KeychainWrapper.standard.set(username, forKey: UserKeychainNameKey) &&
            KeychainWrapper.standard.set(password, forKey: UserKeychainPassKey)
    }
    
    func reset() {
        _ = KeychainWrapper.standard.removeObject(forKey: UserKeychainNameKey)
        _ = KeychainWrapper.standard.removeObject(forKey: UserKeychainPassKey)
    }
    
    func join(completion: @escaping (Bool) -> Void) {
        guard let password = KeychainWrapper.standard.string(forKey: UserKeychainPassKey), let username = KeychainWrapper.standard.string(forKey: UserKeychainNameKey) else {
            return
        }
        
        UserAPIClient.join(username: username, password: password) { result in
            completion(result != nil)
        }
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        guard let username = KeychainWrapper.standard.string(forKey: UserKeychainNameKey), let password = KeychainWrapper.standard.string(forKey: UserKeychainPassKey) else {
            completion(false)
            return
        }
        
        UserAPIClient.login(username: username, password: password) { result in
            if let user = result?.user {
                self.userId = user.id
                UserAPIClient.login(username: username, password: password) { (data) in
                    // Save to Realm
//                    guard let realm = try? Realm(), let user = data?.user else { return }
//
//                    let currentUser = User.withData(user)
//                    try? realm.write {
//                        realm.add(currentUser, update: .modified)
//                    }
                    
                    completion(true)
                }
            }
            
            completion(result != nil)
        }
    }
}
