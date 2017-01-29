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
fileprivate enum Constants {
    static let keyName = "name"
    static let keyStart = "start"
    static let keyStartTimeZone = "startTimeZone"
    static let keyFinish = "finish"
    static let keyFinishTimeZone = "finishTimeZone"
    static let keyDisplayInterval = "displayInterval"
}

extension TimeZone {
    public static var asString : String {
        return TimeZone.current.abbreviation() ?? "UTC"
    }
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
        self.start = DateEnum.stringFrom(date: Date())!
        self.startTimeZone = TimeZone.asString
        self.finish = DateEnum.dateWildCard
        self.finishTimeZone = TimeZone.current.abbreviation() ?? "UTC"
        self.displayInterval = "minute"
    }
    
    init?(name: String, startTime: String = DateEnum.stringFrom(date: Date())!, endTime: String = DateEnum.dateWildCard) {
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
        guard let eventName : String = Constants.keyName <~~ json else {
            return nil
        }
        self.name = eventName
        
        guard let eventStart : String = "start" <~~ json else {
            return nil
        }
        self.start = eventStart
        
        guard let eventFinish : String = "finish" <~~ json else {
            return nil
        }
        self.finish = eventFinish
        
        guard let displayInterval : String = "displayInterval" <~~ json else {
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
            self.finish = builtEvent.finish
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
        guard let built = Event(data) else {
            return nil
        }
        self.name = built.name
        self.start = built.start
        self.finish = built.finish
        self.displayInterval = built.displayInterval
    }

    func toJSON() -> JSON? {  //Uses GLOSS pod
        return jsonify([
            "name" ~~> self.name,
            "start" ~~> self.start,
            "finish" ~~> self.finish,
            "displayInterval" ~~> self.displayInterval
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
