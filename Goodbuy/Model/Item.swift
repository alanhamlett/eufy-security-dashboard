//
//  Item.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/19/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Item: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var listingId: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var title: String?
    @objc dynamic var estimate: Double = 0.0
    @objc dynamic var dateCreated: Double = 0.0
    
    let media = List<ItemMedia>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func withData(_ data: ItemData) -> Item {
        let item = Item()
        item.id = data.id ?? 0
        item.listingId = data.listingId
        item.userId = data.userId
        item.title = data.title
        item.estimate = data.estimate ?? 0
        item.dateCreated = data.dateCreated?.toDate()?.timeIntervalSince1970 ?? 0
        return item
    }
}

struct ItemData: Codable {
    let id: Int?
    let listingId: Int
    let userId: Int
    let title: String?
    let estimate: Double?
    let dateCreated: String?
    let media: ItemMediaData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case listingId = "listing_id"
        case userId = "user_id"
        case title
        case estimate
        case dateCreated = "date_created"
        case media
    }
}
