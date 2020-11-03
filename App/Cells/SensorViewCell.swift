//
//  SensorViewCell.swift
//  Debug
//
//  Created by James Mudgett on 10/29/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

class SensorViewCell: UICollectionViewCell {
    private var data: DevicesResponseData?
    
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.font(ofSize: .title2, weight: .semibold)
        return label
    }()
    
    private let openIcon = UIImageView(image: UIImage(named: "warning"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(titleView)
        contentView.addSubview(openIcon)
        
        openIcon.isHidden = true
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        
        titleView.snp.makeConstraints {
            $0.top.bottom.right.equalTo(0)
            $0.left.equalTo(20)
            $0.width.equalTo(UIScreen.main.bounds.width / 4 - 16 * 2)
            $0.height.equalTo(60)
        }
        
        openIcon.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
        
        updateStyles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
        }
    }
    
    override var isSelected: Bool {
        didSet {
        }
    }
    
    var sensorTypeTitle: String {
        get {
            if let type = data?.deviceType {
                switch type {
                case DeviceType.door:
                    return "Door Sensor"
                case DeviceType.motion:
                    return "Motion Sensor"
                default:
                    break
                }
            }
            return "Sensor"
        }
    }
    
    var deviceName: String {
        get {
            if let name = data?.deviceName {
                return name
            }
            return sensorTypeTitle
        }
    }
    
    var deviceState: DoorSensorState {
        get {
            guard
                let data = data,
                let params = data.params
            else { return DoorSensorState.unknown }
            guard let param = params.first(where: { (param) -> Bool in
                param.type == DeviceParamType.doorSensorState
            }) else { return DoorSensorState.unknown }
            if param.value == "1" {
                return DoorSensorState.open
            }
            if param.value == "0" {
                return DoorSensorState.closed
            }
            return DoorSensorState.unknown
        }
    }
    
    var isOpen: Bool {
        get {
            return deviceState == DoorSensorState.open
        }
    }
    
    var isClosed: Bool {
        get {
            return deviceState == DoorSensorState.closed
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleView.text = ""
        
        updateStyles()
    }
    
    func updateStyles() {
        let dark = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        titleView.textColor = dark ? .white : .black
        contentView.backgroundColor = dark ? UIColor(white: 0.08, alpha: 1) : UIColor(white: 0.98, alpha: 1)
        contentView.layer.borderColor = dark ? UIColor(white: 0.3, alpha: 1).cgColor : UIColor(white: 0.7, alpha: 1).cgColor
    }
    
    func setData(data: DevicesResponseData) {
        self.data = data
        titleView.text = deviceName
        openIcon.isHidden = isClosed
    }
}
