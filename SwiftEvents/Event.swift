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

struct EventInfo {
    let name : String
    let interval : String
    let caption : String
    
    init(name: String, interval: String, caption: String) {
        self.name = name
        self.interval = interval
        self.caption = caption
    }
    
}

struct Event2 : Decodable, Glossy {
    let name : String
    let start : String
    let finish : String
    let displayInterval : String
    
    init() {
        self.name = "First time"
        self.start = DateEnum.stringFrom(date: Date())!
        self.finish = "*"
        self.displayInterval = "minute"
    }
    
    init?(json: JSON) {
        self.name = ("name" <~~ json)!
        self.start = ("start" <~~ json)!
        self.finish = ("finish" <~~ json)!
        self.displayInterval = ("displayInterval" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "name" ~~> self.name,
            "start" ~~> self.start,
            "finish" ~~> self.finish,
            "displayInterval" ~~> self.displayInterval])
    }
    
    func toString() -> String {
        return "{\"name\": \"\(self.name)\",\"start\":\"\(self.start)\",\"finish\":\"\(self.finish)\",\"displayInterval\":\"\(self.displayInterval)\"}"
    }
}

struct Event : Decodable, JSONSerializable, Glossy {
    let name : String
    let start : String
    let finish : String
    let displayInterval : String
    
//    private var intervalType : DateEnum {
//        get {
//            return DateEnum.intervalType(firstDate: self.start, secondDate: self.finish)
//        }
//    }
//    
    var information : EventInfo {
        get {
            return EventInfo(name: self.name, interval: self.publishInterval(), caption: self.publishCaption())
        }
    }
    
    init() {
        self.name = "First used application"
        self.start = DateEnum.stringFrom(date: Date())!
        self.finish = DateEnum.dateWildCard
        self.displayInterval = "minute"
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
        
        self.displayInterval = "minute"
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
        self.displayInterval = displayInterval
    }
    
    func toJSON() -> JSON? {  //Uses GLOSS pod
        return jsonify([
            "eventName" ~~> self.name,
            "startTime" ~~> self.start,
            "endTime" ~~> self.finish,
            "interval" ~~> self.displayInterval
            ])
    }
    
    private func fixedDate() -> String {
        if start == DateEnum.dateWildCard {
            return Date.fromUTC(string: finish)!
        }
        if finish == DateEnum.dateWildCard {
            return Date.fromUTC(string: start)!
        }
        return "\(Date.fromUTC(string: start)!) and \(Date.fromUTC(string: finish)!)"
    }
    
    func publishCaption() -> String {
        let intervalType = DateEnum.intervalType(firstDate: start, secondDate: finish)
        switch intervalType {
        case .since:
            return "Since \(fixedDate())"
        case .until:
            return "Until \(fixedDate())"
        case .between:
            return "Between \(fixedDate())"
        case .invalid:
            return "Invalid: \(start) \(finish)"
        }
    }
    
    func publishInterval(type: DisplayInterval) -> String {
        guard let intervals : DateIntervals = DateIntervals.setFor(startDate: start, endDate: finish) else {
            return "no interval for \(start) \(finish)"
        }
        return intervals.publish(interval: type)
    }
    
    func publishInterval() -> String {
        return publishInterval(type: DisplayInterval.from(string: self.displayInterval))
    }
}
