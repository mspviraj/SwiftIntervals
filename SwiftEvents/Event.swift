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

fileprivate enum Key {
    static let name = "name"
    static let start = "start"
    static let startTimeZone = "startTimeZone"
    static let finish = "finish"
    static let finishTimeZone = "finishTimeZone"
    static let refreshInterval = "refreshInterval"
}


struct Event : Decodable, JSONSerializable, Glossy {
    let name : String
    let start : String
    let startTimeZone: String
    let finish : String
    let finishTimeZone: String
    let refreshInterval : String /// the layout of the display (eg: just seconds?, min,secs?, hours,min,secs?... etc
    
    private var intervalType : DateEnum {
        if start != Formats.wildCard && finish != Formats.wildCard {
            return .between
        }
        switch start.asDate!.compare(finish.asDate!) {
        case .orderedAscending:
            return .since
        case .orderedSame:
            assertionFailure("Identical dates")
            return .invalid
        case .orderedDescending:
            return .until
        }
    }
    
    init() {
        self.name = "First used application"
        self.start = Date().utcString
        self.startTimeZone = TimeZone.current.asString
        self.finish = Formats.wildCard
        self.finishTimeZone = TimeZone.current.asString
        self.refreshInterval = DisplayInterval.progressive.rawValue
    }
    
    init?(name: String, startTime: String = Date().utcString, startTimeZone : TimeZone = TimeZone.current, endTime: String = Formats.wildCard, endTimeZone : TimeZone = TimeZone.current) {
        self.name = name
        
        if let start = startTime.rawDate, let finish = endTime.rawDate {
            self.start = start
            self.startTimeZone = startTimeZone.asString
            self.finish = finish
            self.finishTimeZone = endTimeZone.asString
            self.refreshInterval = "minute"
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
        
        guard let displayInterval : String = Key.refreshInterval <~~ json else {
            return nil
        }
        self.refreshInterval = displayInterval
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
            self.refreshInterval = builtEvent.refreshInterval
        } catch {
            print(error)
            return nil
        }
    }
    
    init?(string: String) {
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
        self.refreshInterval = builtEvent.refreshInterval
    }
    
    func toJSON() -> JSON? {  //Uses GLOSS pod
        return jsonify([
            Key.name ~~> self.name,
            Key.start ~~> self.start,
            Key.startTimeZone ~~> self.startTimeZone,
            Key.finish ~~> self.finish,
            Key.finishTimeZone ~~> self.finishTimeZone,
            Key.refreshInterval ~~> self.refreshInterval
            ])
    }
    
    private func fixedDate() -> String {
        if start == Formats.wildCard {
            return finishAs(.full)
        }
        if finish == Formats.wildCard {
            return startAs(.full)
        }
        return "\(startAs(.full)) and \(finishAs(.full))"
    }
    
    func publishCaption() -> String {
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
    
    func startAs(_ format: Formats) -> String {
        return start.formatAs(format, withTimeZone: self.startTimeZone)!
    }
    
    func finishAs(_ format: Formats) -> String {
        return finish.formatAs(format, withTimeZone: self.finishTimeZone)!
    }
    
    func publishInterval(_ interval: DisplayInterval? = nil) -> String {
        guard let dateIntervals = DateIntervals.setFor(startDate: start, endDate: finish) else {
            return "Invalid \(start) \(finish)"
        }
        return dateIntervals.publish(interval: (interval == nil) ? DisplayInterval.from(string: refreshInterval) : interval!)
    }
}
