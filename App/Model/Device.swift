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
    case station = 0
    case camera = 1
    case door = 2
    case floodlight = 3
    case camera_e = 4
    case doorbell = 5
    case battery_doorbell = 7
    case camera_2c = 8
    case camera_2 = 9
    case motion = 10
    case keypad = 11
    case camera_2_pro = 14
    case camera_2c_pro = 15
    case battery_doorbell_2 = 16
    case indoor_camera = 30
    case solo_camera = 32
    case solo_camera_pro = 33
    case indoor_camera_1080 = 34
    case indoor_pt_camera = 31
    case indoor_pt_camera_1080 = 35
    case lock_basic = 50
    case lock_advanced = 51
    case lock_basic_no_finger = 52
    case lock_advanced_no_finger = 53
    case solo_camera_spotlight_1080 = 60
    case solo_camera_spotlight_2k = 61
    case solo_camera_spotlight_solar = 62
    case other = -1

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
    let id: Int?
    let name: String?
    let type: DeviceType?
    let thumbnail: String?
    let thumbnailUpdatedAt: Int?
    let params: [DeviceParam]?

    // Streaming request data needed
    let serialNumber: String?
    let stationSerialNumber: String?

    enum CodingKeys: String, CodingKey {
        case id = "device_id"
        case name = "device_name"
        case type = "device_type"
        case thumbnail = "cover_path"
        case thumbnailUpdatedAt = "cover_time"
        case serialNumber = "device_sn"
        case stationSerialNumber = "station_sn"
        case params = "params"
    }
}
