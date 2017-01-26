//
//  Preferences.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/24/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import Gloss

struct Preferences : JSONSerializable, Glossy {
    var refreshInSeconds : Int?
    var lastCloudUpdate : String?
    
    init(refreshRate: RefreshRates = RefreshRates.minute, lastCloudUpdate: Date = Date()) {
        self.refreshInSeconds = refreshRate.asSeconds()
        self.lastCloudUpdate = DateEnum.stringFrom(date: lastCloudUpdate)!
    }
    
    init?(jsonString: String) {
        guard let dict = jsonString.toDictionary() else {
            return nil
        }
        guard let refresh = dict["refreshInSeconds"] else {
            return nil
        }
        self.refreshInSeconds = refresh as? Int
        guard let update = dict["lastCloudUpdate"] else {
            return nil
        }
        self.lastCloudUpdate = update as? String
        
    }
    
    //Glossy protocol
    internal init?(json: JSON) {
        self.refreshInSeconds = ("refreshInSeconds" <~~ json)
        self.lastCloudUpdate = ("lastCloudUpdate" <~~ json)
    }
    
    //Glossy protocol
    internal func toJSON() -> JSON? {
        return jsonify([
            "refreshInSeconds" ~~> self.refreshInSeconds,
            "lastCloudUpdate" ~~> self.lastCloudUpdate
            ])
    }
    
    func save(withKey key: String = "Preferences") {
        guard let jsonString = self.toString() else {
            assertionFailure("Could not convert to string")
            return
        }
        CloudManager.save(json: jsonString, withKey: key)
    }
    
    static func get(withKey key: String = "Preferences") -> Preferences {
        if let jsonString = CloudManager.get(withKey: key) {
            if let result = Preferences(jsonString: jsonString) {
                return result
            }
            assertionFailure("Cannot create prefrences from:\(jsonString)")
        }
        let pref = Preferences()
        pref.save(withKey: key)
        return pref
    }
}
