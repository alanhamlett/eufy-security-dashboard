//
//  Hotline.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Listing: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var user: User?
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var minimum: Double = 0.0
    @objc dynamic var asking: Double = 0.0
    @objc dynamic var highBid: Double = 0.0
    @objc dynamic var cancelled: Bool = false
    @objc dynamic var auction: Bool = false
    @objc dynamic var dateCreated: Double = 0.0
    @objc dynamic var expires: Double = 0.0
    
//    let items = List<User>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func withData(_ data: ListingData) -> Listing {
        let listing = Listing()
        listing.id = data.id ?? 0
        listing.user = User.withData(data.user!)
        listing.title = data.title
        listing.desc = data.description
        listing.minimum = data.minimum ?? 0
        listing.asking = data.asking ?? 0
        listing.highBid = data.highBid ?? 0
        listing.cancelled = data.cancelled ?? false
        listing.auction = data.auction ?? false
        listing.dateCreated = data.dateCreated?.toDate()?.timeIntervalSince1970 ?? 0
        listing.expires = data.expires?.toDate()?.timeIntervalSince1970 ?? 0
        return listing
    }
}

struct ListingData: Codable {
    let id: Int?
    let user: UserData?
    let title: String?
    let description: String?
    let minimum: Double?
    let asking: Double?
    let highBid: Double?
    let cancelled: Bool?
    let auction: Bool?
    let dateCreated: String?
    let expires: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case title
        case description
        case minimum
        case asking
        case highBid = "high_bid"
        case cancelled
        case auction
        case dateCreated = "date_created"
        case expires
    }
}
