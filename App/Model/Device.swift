//
//  Device.swift
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
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

enum DeviceParamType: Int, Codable {
    case doorSensorState = 1550
    case unknown = 0

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(Int.self)
        self = DeviceParamType(rawValue: raw) ?? .unknown
    }
}

struct DeviceParam: Codable {
    let type: DeviceParamType
    let value: String?
    let updatedAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case type = "param_type"
        case value = "param_value"
        case updatedAt = "update_time"
    }
}

enum DoorSensorState: String {
    case open = "Open"
    case closed = "Closed"
    case unknown = "Unknown"
}

struct DevicesResponseData: Codable {
    let deviceId: Int?
    let deviceName: String?
    let deviceType: DeviceType?
    let thumbnail: String?
    let thumbnailUpdatedAt: Int?
    let params: [DeviceParam]?
    
    // Streaming request data needed
    let deviceSN: String?
    let stationSN: String?
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case deviceName = "device_name"
        case deviceType = "device_type"
        case thumbnail = "cover_path"
        case thumbnailUpdatedAt = "cover_time"
        case deviceSN = "device_sn"
        case stationSN = "station_sn"
        case params = "params"
    }
}
