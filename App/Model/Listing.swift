//
//  Hotline.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation

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
