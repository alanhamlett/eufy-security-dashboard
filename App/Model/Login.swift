//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
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
    let domain: String?
    
    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case domain = "domain"
    }
}
