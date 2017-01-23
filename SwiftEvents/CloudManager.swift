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
    func deleteEvents(withKey key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    func getEvents(withKey key: String) -> Events? {
        let defaults = UserDefaults.standard
        guard let content : String = defaults.object(forKey: key) as? String else {
            return Events()
        }
        print("\(content)")
        guard let data = content.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        guard let events = Events(data) else {
            return nil
        }
        return events
    }
    
    func saveEvents(_ events: Events, withKey key: String) -> Bool {
        guard let eventsAsString = events.toString() else {
            return false
        }
        let defaults = UserDefaults.standard
        defaults.set(eventsAsString, forKey: key)
        defaults.synchronize()
        return true
    }
}
