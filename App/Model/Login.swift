//
//  Login.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

import Foundation

struct LoginData: Codable {
    let email: String?
    let password: String?
}

struct LoginResponse: Codable {
    let code: Int
    let msg: String?
    let data: LoginResponseData
}

struct LoginResponseData: Codable {
    let authToken: String?
    let tokenExpiresAt: Int?
    let domain: String?
    
    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case tokenExpiresAt = "token_expires_at"
        case domain = "domain"
    }
}
