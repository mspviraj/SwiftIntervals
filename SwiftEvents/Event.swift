//
//  Event.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/9/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import Gloss


struct Event : JSONSerializable, Glossy {
    private let eventStart : String
    private let eventFinish : String
    
    let eventName : String
    var startTime : Date {
        get {
            return DateEnum.dateFrom(string: eventStart)!
        }
    }
    var endTime : Date {
        get {
            return DateEnum.dateFrom(string: eventStart)!
        }
    }
    
    init?(_ eventName: String, startTime: String, endTime: String = DateEnum.dateWildCard) {
        guard DateEnum.dateFrom(string: startTime) != nil else {
            return nil
        }
        guard DateEnum.dateFrom(string: endTime) != nil else {
            return nil
        }
        self.eventName = eventName
        self.eventStart = startTime
        self.eventFinish = endTime
    }
    
    
    init() {
        self.eventName = "Started using this app"
        self.eventStart = DateEnum.stringFrom(date: Date())!
        self.eventFinish = DateEnum.dateWildCard
    }
    
    init?(json: JSON) {
        guard let eventName : String = "eventName" <~~ json else {
            return nil
        }
        self.eventName = eventName
        
        guard let startTime : String = "startTime" <~~ json else {
            return nil
        }
        self.eventStart = startTime
        
        guard  let endTime : String = "endTime" <~~ json else {
            return nil
        }
        self.eventFinish = endTime
    }
    
    func toJSON() -> JSON? {  //Uses GLOSS pod
        return jsonify([
            "eventName" ~~> self.eventName,
            "startTime" ~~> self.startTime,
            "endTime" ~~> self.endTime
            ])
    }
}
