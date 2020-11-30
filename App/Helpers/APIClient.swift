//
//  APIClient.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

let apiUrl = "https://mysecurity.eufylife.com/api/v1"
let BearerKeychainNameKey = "BearerTokenKey"
let ExpiresAtKeychainNameKey = "BearerExpiresKey"
let DomainKeychainNameKey = "AccessDomain"

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }
}

class APIClient {
    class func setBearer(response: LoginResponse) {
        _ = KeychainWrapper.standard.set(response.data.authToken ?? "", forKey: BearerKeychainNameKey)
        _ = KeychainWrapper.standard.set(String(keyresponse.data.tokenExpiresAt ?? 0), forKey: ExpiresAtKeychainNameKey)
    }
    
    class func setAccessDomain(response: LoginResponse) {
        _ = KeychainWrapper.standard.set(response.data.domain ?? "", forKey: DomainKeychainNameKey)
    }
    
    class func getBearer() -> String? {
        guard
            let expiresData = KeychainWrapper.standard.string(forKey: BearerKeychainNameKey),
            let expiresAt = expiresData.toInt(),
            expiresAt < Date().timeIntervalSince1970
        else { return nil }
        return KeychainWrapper.standard.string(forKey: BearerKeychainNameKey)
    }
    
    class func getAccessDomain() -> String? {
        return KeychainWrapper.standard.string(forKey: DomainKeychainNameKey)
    }
}

class UserAPIClient: APIClient {
    static func login(email: String, password: String, completion: @escaping (LoginResponse?) -> Void) {
        guard let url = URL(string: apiUrl)?.appendingPathComponent("passport/login") else { return }
        
        let loginData = LoginData(email: email, password: password)
        
        var request = URLRequest(url: url)
        let session = URLSession.shared
        let jsonData = try? JSONEncoder().encode(loginData)
        
        request.httpMethod = "POST"
        request.setValue("EufySecurityDashboard/\(AppDelegate.shared.appVersion)", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.httpBody = jsonData
        
        session.dataTask(with: request) {data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil)
                return
            }

            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                self.setBearer(response: data)
                self.setAccessDomain(response: data)
                
                completion(data)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
    static func devices(completion: @escaping (DevicesResponse?) -> Void) {
        guard let url = URL(string: apiUrl)?.appendingPathComponent("app/get_devs_list") else { return }
        
        var request = URLRequest(url: url)
        let session = URLSession.shared
        
        guard let bearerToken = getBearer() else { return }
        
        request.httpMethod = "POST"
        request.setValue("EufySecurityDashboard/\(AppDelegate.shared.appVersion)", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue(bearerToken, forHTTPHeaderField: "x-auth-token")
        
        session.dataTask(with: request) {data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            guard let data = data else { return }
            do {
//                debugPrint(String(data: data, encoding: String.Encoding.utf8) ?? "{}")
                
                let data = try JSONDecoder().decode(DevicesResponse.self, from: data)
                completion(data)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
