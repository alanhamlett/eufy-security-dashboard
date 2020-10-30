//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation

struct DevicesResponse: Codable {
    let banned: Int?
    let code: Int?
    let msg: String?
    let data: [DevicesResponseData]?
}

enum DeviceType: Int, Codable {
    case camera = 1
    case door = 2
    case motion = 10
    case other = 0

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(Int.self)
        self = DeviceType(rawValue: raw) ?? .other
    }
}

struct DevicesResponseData: Codable {
    let deviceId: Int?
    let deviceName: String?
    let deviceType: DeviceType?
    let thumbnail: String?
    let timestamp: Int?
    
    // Streaming request data needed
    let deviceSN: String?
    let stationSN: String?
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case deviceName = "device_name"
        case deviceType = "device_type"
        case thumbnail = "cover_path"
        case timestamp = "update_time"
        case deviceSN = "device_sn"
        case stationSN = "station_sn"
    }
}
