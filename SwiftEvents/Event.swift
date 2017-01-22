//
//  Event.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/9/17.
//  Copyright © 2017 LTMM. All rights reserved.
//
// Single event with caption, start time, end time, and refresh interval
//
import Foundation
import Gloss

struct Event : JSONSerializable, Glossy {
    let name : String
    let start : String
    let finish : String
    let displayInterval : DisplayInterval
    
    init() {
        self.name = "First used application"
        self.start = DateEnum.stringFrom(date: Date())!
        self.finish = DateEnum.dateWildCard
        self.displayInterval = DisplayInterval.minute
    }
    
    init?(name: String, startTime: String, endTime: String = DateEnum.dateWildCard) {
        self.name = name
        
        guard DateEnum.dateFrom(string: startTime) != nil else {
            return nil
        }
        self.start = startTime
        
        guard DateEnum.dateFrom(string: endTime) != nil else {
            return nil
        }
        self.finish = endTime
        
        self.displayInterval = DisplayInterval.minute
    }
    
    init?(json: JSON) {
        guard let eventName : String = "eventName" <~~ json else {
            return nil
        }
        self.name = eventName
        
        guard let eventStart : String = "startTime" <~~ json else {
            return nil
        }
        self.start = eventStart
        
        guard let eventFinish : String = "endTime" <~~ json else {
            return nil
        }
        self.finish = eventFinish
        
        guard let displayInterval : String = "interval" <~~ json else {
            return nil
        }
        self.displayInterval = DisplayInterval.from(string: displayInterval)
    }
    
    func toJSON() -> JSON? {  //Uses GLOSS pod
        return jsonify([
            "eventName" ~~> self.name,
            "startTime" ~~> self.start,
            "endTime" ~~> self.finish,
            "interval" ~~> self.displayInterval.rawValue
            ])
    }
    
}
