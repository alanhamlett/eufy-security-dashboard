//
//  APIClient.swift
//  Hotline
//
//  Created by James Mudgett on 2/11/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

let apiUrl = "http://goodbuy-api.herokuapp.com/v1/"
//let apiUrl = "http://localhost:5000/v1/"
let BearerKeychainNameKey = "BearerTokenKey"
let BearerIdKeychainNameKey = "BearerIdTokenKey"

struct ResponseMessage: Codable {
    let token: String?
    let user: UserData?
}

struct TokenData: Decodable {
    let id: Int
    let token: String
    let userID: Int
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }
}

class APIClient {
    class func setBearer(response: ResponseMessage) {
        _ = KeychainWrapper.standard.set(response.token ?? "", forKey: BearerKeychainNameKey)
        _ = KeychainWrapper.standard.set(response.user?.id ?? 0, forKey: BearerIdKeychainNameKey)
    }
    
    class func getBearer() -> String? {
        return KeychainWrapper.standard.string(forKey: BearerKeychainNameKey)
    }
}

class UserAPIClient: APIClient {
    static func join(username: String, password: String, completion: @escaping (ResponseMessage?) -> Void) {
        let loginData = LoginData(username: username, password: password)
        
        guard let url = URL(string: apiUrl + "account") else { return }
        
        var request = URLRequest(url: url)
        let session = URLSession.shared
        let jsonData = try? JSONEncoder().encode(loginData)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        debugPrint(request)

        session.dataTask(with: request) {data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                debugPrint(json)
                
                let data = try JSONDecoder().decode(ResponseMessage.self, from: data)
                completion(data)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
    static func login(username: String, password: String, completion: @escaping (ResponseMessage?) -> Void) {
        guard let url = URL(string: apiUrl + "account/login") else { return }
        let loginData = LoginData(username: username, password: password)
        
        var request = URLRequest(url: url)
        let session = URLSession.shared
        let jsonData = try? JSONEncoder().encode(loginData)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        session.dataTask(with: request) {data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode(ResponseMessage.self, from: data)
                
                self.setBearer(response: data)
                
                completion(data)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
