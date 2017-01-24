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
    
    init(refreshInSeconds: Int = 60, lastCloudUpdate: Date = Date()) {
        self.refreshInSeconds = refreshInSeconds
        self.lastCloudUpdate = DateEnum.stringFrom(date: lastCloudUpdate)!
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
    
    
    
}
