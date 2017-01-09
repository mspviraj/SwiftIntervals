//
//  Event.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/9/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import Gloss

struct Event : Decodable {
    private let keyEvent = "eventName"
    private let keyStart = "startTime"
    private let keyEnd = "endTime"
    
    let eventName : String?
    let startTime : String?
    let endTime : String?
    
    init?(json: JSON) {
        guard let eventName : String = keyEvent <~~ json else {
            return nil
        }
        self.eventName = eventName
        
        guard let startTime : String = keyStart <~~ json else {
            return nil
        }
        self.startTime = startTime
        
        guard  let endTime : String = keyEnd <~~ json else {
            return nil
        }
        self.endTime = endTime
    }
    
    init(_ eventName: String, startTime: String, endTime: String) {
        self.eventName = eventName
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            keyEvent ~~> self.eventName,
            keyStart ~~> self.startTime,
            keyEnd ~~> self.endTime
        ])
    }
    
}
