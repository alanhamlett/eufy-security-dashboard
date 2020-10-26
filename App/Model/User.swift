//
//  User.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let id: Int?
    let username: String?
    let location: String?
    let address: String?
    let city: String?
    let state: String?
    let zip: String?
    let rating: Double?
    let avatar: String?
    let emailVerified: Bool?
    let mobileVerified: Bool?
    let dateCreated: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case location
        case address
        case city
        case state
        case zip
        case rating
        case avatar
        case emailVerified = "email_verified"
        case mobileVerified = "mobile_verified"
        case dateCreated = "date_created"
    }
}
