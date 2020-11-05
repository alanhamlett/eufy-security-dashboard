//
//  ThumbnailManager.swift
//
//  Created by Alan Hamlett on 11/4/20.
//  Copyright © 2020 Alan Hamlett. All rights reserved.
//

private struct CachedDevice {
    let serialNumber: String?
    let updatedAt: Int?
    let thumbnailUrl: String?
    
    init(from device: DevicesResponseData) {
        serialNumber = device.serialNumber
        updatedAt = device.thumbnailUpdatedAt
        thumbnailUrl = device.thumbnail
    }
}

final class ThumbnailManager {
    static let shared = ThumbnailManager()

    private var deviceCache = [String: CachedDevice]()
    
    private init() { }

    subscript(device: DevicesResponseData) -> String? {
        get {
            guard let serialNumber = device.serialNumber else { return device.thumbnail }
            guard let cached = deviceCache[serialNumber] else {
                deviceCache[serialNumber] = CachedDevice(from: device)
                return device.thumbnail
            }
            if
                let oldUpdatedAt = cached.updatedAt,
                let newUpdatedAt = device.thumbnailUpdatedAt,
                oldUpdatedAt == newUpdatedAt
            {
                return cached.thumbnailUrl
            }
            deviceCache[serialNumber] = CachedDevice(from: device)
            return device.thumbnail
        }
    }
}
