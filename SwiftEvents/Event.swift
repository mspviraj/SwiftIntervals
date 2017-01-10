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
    let eventName : String?
    let startTime : String?
    let endTime : String?
 
    init?(_ eventName: String, startTime: String, endTime: String = DateEnum.dateWildCard) {
        if startTime != DateEnum.dateWildCard {
            guard DateEnum.dateFromString(startTime) != nil else {
                return nil
            }
        }
        if endTime != DateEnum.dateWildCard {
            guard DateEnum.dateFromString(endTime) != nil else {
                return nil
            }
        }
        self.eventName = eventName
        self.startTime = startTime
        self.endTime = endTime
    }

    
    init() {
        self.eventName = "Started using this app"
        self.startTime = DateEnum.stringFromDate(Date())
        self.endTime = DateEnum.dateWildCard
    }
    
    init?(_ eventName: String, startDate: Date = Date(), endDate: String = DateEnum.dateWildCard) {
        if let build = Event(eventName, startTime: DateEnum.stringFromDate(Date())!,endTime: endDate) {
            self.eventName = build.eventName
            self.startTime = build.startTime
            self.endTime = build.endTime
        } else {
            return nil
        }
    }
    
    init?(json: JSON) {
        guard let eventName : String = "eventName" <~~ json else {
            return nil
        }
        self.eventName = eventName
        
        guard let startTime : String = "startTime" <~~ json else {
            return nil
        }
        self.startTime = startTime
        
        guard  let endTime : String = "endTime" <~~ json else {
            return nil
        }
        self.endTime = endTime
    }
    
//    init?(_ string: String) {
//        guard let data = string.data(using: .utf8) else {
//            return nil
//        }
//        do {
//            var json : JSON? = [:]
//            try json = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON
//            let build = Event(json: json!)
//            self.eventName = build!.eventName
//            self.startTime = build!.startTime
//            self.endTime = build!.endTime
//        } catch {
//            print(error)
//            return nil
//        }
//    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "eventName" ~~> self.eventName,
            "startTime" ~~> self.startTime,
            "endTime" ~~> self.endTime
            ])
    }
    
}
