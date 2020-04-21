//
//  ItemMedia.swift
//  Goodbuy
//
//  Created by James Mudgett on 4/19/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ItemMedia: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var listingId: Int = 0
    @objc dynamic var url: String?
    @objc dynamic var fileUrl: String?
    @objc dynamic var flagged: Bool = false
    @objc dynamic var isVideo: Bool = false
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var dateCreated: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func withData(_ data: ItemMediaData) -> ItemMedia {
        let media = ItemMedia()
        media.id = data.id ?? 0
        media.listingId = data.listingId ?? 0
        media.url = data.url
        media.flagged = data.flagged ?? false
        media.isVideo = data.isVideo ?? false
        media.sortOrder = data.sortOrder ?? 0
        media.dateCreated = data.dateCreated?.toDate()?.timeIntervalSince1970 ?? 0
        return media
    }
}

struct ItemMediaData: Codable {
    let id: Int?
    let listingId: Int?
    let url: String?
    let flagged: Bool?
    let isVideo: Bool?
    let sortOrder: Int?
    let dateCreated: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case listingId = "listing_id"
        case url
        case flagged
        case isVideo = "is_video"
        case sortOrder = "sort_order"
        case dateCreated = "date_created"
    }
}

