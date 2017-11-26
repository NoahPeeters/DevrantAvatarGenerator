//
//  AvatarProperty.swift
//  DevrantAvatar
//
//  Created by Noah Peeters on 10/28/17.
//  Copyright © 2017 Noah Peeters. All rights reserved.
//

import Foundation

struct AvatarProperty {
    var value: Int
    let type: AvatarPropertyType
    
    init(_ value: Int, ofType type: AvatarPropertyType) {
        self.value = value
        self.type = type
    }
    
    var urlString: String {
        guard let converter = type.converter else {
            return "\(type.urlName)-\(value)"
        }
        return "\(type.urlName)-\(converter(value))"
    }
}

struct Avatar {
    let properties: [AvatarProperty]
    
    init(_ properties: [AvatarProperty]) {
        self.properties = properties
    }
    
    private var pathComponent: String {
        return properties.map({ $0.urlString }).joined(separator: "_")
    }
    
    func url(withBaseURL baseURL: URL, withFileType fileType: AvatarFileType) -> URL {
        return baseURL.appendingPathComponent(pathComponent).appendingPathExtension(fileType.rawValue)
    }
}

enum AvatarFileType: String {
    case png
    case jpg
    
    static let all: [AvatarFileType] = [.png, .jpg]
    
    var displayName: String {
        switch self {
        case .png:
            return "PNG"
        case .jpg:
            return "JPG"
        }
    }
}
