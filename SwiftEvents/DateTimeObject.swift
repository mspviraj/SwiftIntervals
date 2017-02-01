//
//  DateTimeObject.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/31/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

struct DateTimeObject {
    private var dateTime : String
    private var timeZone : String
    
    public var date : String {
        get {
            return dateTime.formatAs(.date, withTimeZone: timeZone.asTimeZone!)!
        }
    }
    
    public var time : String {
        get {
            return dateTime.formatAs(.time, withTimeZone: timeZone.asTimeZone!)!
        }
    }
    
    init?(dateTime: String = Date().utcString, timeZone: String = TimeZone.autoupdatingCurrent.identifier) {
        guard dateTime.asDate != nil && timeZone.asTimeZone != nil else {
            return nil
        }
        self.dateTime = dateTime
        self.timeZone = timeZone
    }
    
    public mutating func setDate(with date: Date, withTimeZone zone: TimeZone? = nil) {
        let calendar = Calendar.current
        let dateItems = calendar.dateComponents([.year, .month, .day], from: date)
        let timeItems = calendar.dateComponents([.hour, .minute, .second], from: dateTime.asDate!)
        dateTime = buildDate(dateItems: dateItems, timeItems: timeItems, timeZone: zone == nil ? TimeZone.autoupdatingCurrent : timeZone.asTimeZone!).utcString
    }
    
    public mutating func setTime(with time: Date, withTimeZone zone: TimeZone? = nil) {
        let calendar = Calendar.current
        let dateItems = calendar.dateComponents([.year, .month, .day], from: dateTime.asDate!)
        let timeItems = calendar.dateComponents([.hour, .minute, .second], from: time)
        dateTime = buildDate(dateItems: dateItems, timeItems: timeItems, timeZone: zone == nil ? TimeZone.autoupdatingCurrent : timeZone.asTimeZone!).utcString
    }
    
    
    private func buildDate(dateItems: DateComponents, timeItems: DateComponents, timeZone: TimeZone) -> Date {
        let newComponents = DateComponents(calendar: nil,
                                           timeZone: timeZone,
                                           era: nil,
                                           year: dateItems.year,
                                           month: dateItems.month,
                                           day: dateItems.day,
                                           hour: timeItems.hour,
                                           minute: timeItems.minute,
                                           second: timeItems.second,
                                           nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return Calendar.current.date(from: newComponents)!
    }
    
}
