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

fileprivate enum Key {
    static let name = "name"
    static let start = "start"
    static let startTimeZone = "startTimeZone"
    static let finish = "finish"
    static let finishTimeZone = "finishTimeZone"
    static let displayInterval = "displayInterval"
}


struct Event : Decodable, JSONSerializable, Glossy {
    let name : String
    let start : String
    let startTimeZone: String
    let finish : String
    let finishTimeZone: String
    let displayInterval : String
    
    var startDate : Date { get { return DateEnum.dateFrom(string: start)! }}
    var finishDate : Date { get { return DateEnum.dateFrom(string: finish)! }}
    
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
        self.start = Date().utcString
        self.startTimeZone = TimeZone.current.asString
        self.finish = Formats.wildCard
        self.finishTimeZone = TimeZone.current.asString
        self.displayInterval = "minute"
    }
    
    init?(name: String, startTime: String = Date().utcString, startTimeZone : TimeZone = TimeZone.current, endTime: String = Formats.wildCard, endTimeZone : TimeZone = TimeZone.current) {
        self.name = name
        
        if let start = startTime.rawDate, let finish = endTime.rawDate {
            self.start = start
            self.startTimeZone = startTimeZone.asString
            self.finish = finish
            self.finishTimeZone = endTimeZone.asString
            self.displayInterval = "minute"
        } else {
            return nil
        }
    }
    
    init?(json: JSON) {
        guard let eventName : String = Key.name <~~ json else {
            return nil
        }
        self.name = eventName
        
        guard let eventStart : String = Key.start <~~ json else {
            return nil
        }
        self.start = eventStart
        
        guard let startTimeZone : String = Key.startTimeZone <~~ json else {
            return nil
        }
        self.startTimeZone = startTimeZone
        
        guard let eventFinish : String = Key.finish <~~ json else {
            return nil
        }
        self.finish = eventFinish
        
        guard let finishTimeZone : String = Key.finishTimeZone <~~ json else {
            return nil
        }
        self.finishTimeZone = finishTimeZone
        
        guard let displayInterval : String = Key.displayInterval <~~ json else {
            return nil
        }
        self.displayInterval = displayInterval
    }
    
    init?(_ data : Data) {
        do {
            var convertedJSON : JSON? = [:]
            try convertedJSON = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON
            guard let json = convertedJSON else {
                return nil
            }
            guard let builtEvent = Event(json: json) else {
                return nil
            }
            self.name = builtEvent.name
            self.start = builtEvent.start
            self.startTimeZone = builtEvent.startTimeZone
            self.finish = builtEvent.finish
            self.finishTimeZone = builtEvent.finishTimeZone
            self.displayInterval = builtEvent.displayInterval
        } catch {
            print(error)
            return nil
        }
    }
    
    init?(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        guard let builtEvent = Event(data) else {
            return nil
        }
        self.name = builtEvent.name
        self.start = builtEvent.start
        self.startTimeZone = builtEvent.startTimeZone
        self.finish = builtEvent.finish
        self.finishTimeZone = builtEvent.finishTimeZone
        self.displayInterval = builtEvent.displayInterval
    }

    func toJSON() -> JSON? {  //Uses GLOSS pod
        return jsonify([
            Key.name ~~> self.name,
            Key.start ~~> self.start,
            Key.startTimeZone ~~> self.startTimeZone,
            Key.finish ~~> self.finish,
            Key.finishTimeZone ~~> self.finishTimeZone,
            Key.displayInterval ~~> self.displayInterval
            ])
    }
    
    private func fixedDate() -> String {
        if start == Formats.wildCard {
            return self.finish.display(timeZoneString: self.finishTimeZone)
        }
        if finish == Formats.wildCard {
            return self.start.display(timeZoneString: self.startTimeZone)
        }
        return "\(self.start.display(timeZoneString: self.startTimeZone)) and \(self.start.display(timeZoneString: self.startTimeZone))"
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
