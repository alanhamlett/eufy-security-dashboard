//
//  User.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var username: String?
    @objc dynamic var email: String?
    @objc dynamic var location: String?
    @objc dynamic var address: String?
    @objc dynamic var city: String?
    @objc dynamic var state: String?
    @objc dynamic var zip: String?
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var avatar: String?
    @objc dynamic var emailVerified: Bool = false
    @objc dynamic var mobileVerified: Bool = false
    @objc dynamic var dateCreated: Double = 0.0
    let listings = List<Listing>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func withData(_ data: UserData) -> User {
        let user = User()
        user.id = data.id ?? 0
        user.username = data.username
        user.location = data.location
        user.address = data.address
        user.city = data.city
        user.state = data.state
        user.zip = data.zip
        user.rating = data.rating ?? 0
        user.avatar = data.avatar
        user.emailVerified = data.emailVerified ?? false
        user.mobileVerified = data.mobileVerified ?? false
        user.dateCreated = data.dateCreated?.toDate()?.timeIntervalSince1970 ?? 0
        return user
    }
}

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
