//
//  AvatarPropertyType.swift
//  DevrantAvatar
//
//  Created by Noah Peeters on 10/28/17.
//  Copyright © 2017 Noah Peeters. All rights reserved.
//

import Foundation

typealias Converter = (Int) -> String

struct AvatarPropertyType {
    let displayName: String
    let urlName: String
    let valueDisplayNames: [String]?
    let minValue: Int
    let maxValue: Int
    let defaultValue: Int?
    let converter: Converter?
    
    var optionsCount: Int {
        return maxValue - minValue + 1
    }
    
    init(_ displayName: String, urlName: String, minValue: Int = 1, maxValue: Int, defaultValue: Int? = nil, converter: Converter? = nil) {
        self.displayName = displayName
        self.urlName = urlName
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue
        self.valueDisplayNames = nil
        self.converter = converter
    }
    
    init(_ displayName: String, urlName: String, minValue: Int = 1, defaultValue: Int? = nil, valueDisplayNames: [String], converter: Converter? = nil) {
        self.displayName = displayName
        self.urlName = urlName
        self.minValue = minValue
        self.maxValue = valueDisplayNames.count - 1 + minValue
        self.defaultValue = defaultValue
        self.valueDisplayNames = valueDisplayNames
        self.converter = converter
    }
    
    func withValue(_ value: Int) -> AvatarProperty {
        return AvatarProperty(value, ofType: self)
    }
    
    func withRandomValue() -> AvatarProperty {
        let value = defaultValue ?? Int(arc4random_uniform(UInt32(maxValue - minValue))) + minValue
        
        return withValue(value)
    }
    
    static let allTypes = [
        AvatarPropertyType("Type", urlName: "c", defaultValue: 1, valueDisplayNames: [
            "Full Square", "Small", "Face 1", "Table", "Face 2", "Large", "Body 1", "Square Small", "Arm", "Foots", "Body 2", "IDK", "Face 3", "Body 3", "Accessoire Left", "Accessoire Right"
        ]),
        AvatarPropertyType("Background Color", urlName: "b", valueDisplayNames: [
            "Green", "Purple", "Orange", "Blue", "Red", "Light Blue", "Yellow"
        ]),
        AvatarPropertyType("Gender", urlName: "g", minValue: 0, valueDisplayNames: [
            "Male", "Female"
        ]) { ["m", "f"][$0] },
        AvatarPropertyType("Skin Tone", urlName: "1", maxValue: 13),
        AvatarPropertyType("Shirt", urlName: "2", maxValue: 105),
        AvatarPropertyType("Trouser", urlName: "3", maxValue: 14),
        AvatarPropertyType("Computer", urlName: "5", valueDisplayNames: [
            "Laptop Light", "Laptop Dark", "iMac", "Two Screens"
        ]),
        AvatarPropertyType("Hair", urlName: "6", maxValue: 110),
        AvatarPropertyType("Table", urlName: "8", valueDisplayNames: [
            "White", "Wood light", "Wood dark", "Glass"
        ]),
        AvatarPropertyType("Chair", urlName: "9", valueDisplayNames: [
            "Chair", "Ball",
        ]),
    ]
}

