//
//  CloudManager.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/23/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

enum UserInfoKeys: String {
    case servicePayload
    case cloudCode, cloudType, cloudData
}

enum CloudTypes: String {
    case fromDropbox
    case fromICloud
}

enum CloudCodes: String {
    case error
    case ok
    case progress
    case notFile
    case notFound
    case other
}

struct CloudManager {
    static func delete(withKey key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    static func get(withKey key: String) -> String? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) as? String
    }
    
    static func save(json: String, withKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(json, forKey: key)
        defaults.synchronize()
    }
    
    
}
