//
//  NextTime.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/23/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

extension Date {
    struct Gregorian {
        static let calendar = Calendar(identifier: .gregorian)
    }
    var nextHourShift: Date? {
        return Gregorian.calendar.nextDate(after: self, matching: DateComponents(minute: 0), matchingPolicy: .nextTime)
    }
    func nextWith(gap: Int) -> Date? {
        switch gap {
        case 1:
            return Gregorian.calendar.nextDate(after: self, matching: DateComponents(second: 0), matchingPolicy: .nextTime) // nearest minute
        case 60:
            return Gregorian.calendar.nextDate(after: self, matching: DateComponents(minute: 0), matchingPolicy: .nextTime) // nearest hour
        default:
            return Gregorian.calendar.nextDate(after: self, matching: DateComponents(minute: gap), matchingPolicy: .nextTime) //next fraction of hour
        }
    }
}

struct NextTime {
    static func with(date: Date, refreshRate : RefreshRates = RefreshRates.minute) -> Date {
        
        switch refreshRate {
        case .second:
            return Date()
        case .minute:
            return date.nextWith(gap: 1)!
        case .fiveMinutes:
            let gap = nextPoint(date: date, points:[5,10,15,20,25,30,35,40,45,50,55,60])
            return date.nextWith(gap: gap)!
        case .fifteenMinutes:
            let gap = nextPoint(date: date, points:[15,30,45,60])
            return date.nextWith(gap: gap)!
        case .thirtyMinutes:
            let gap = nextPoint(date: date, points:[30,60])
            return date.nextWith(gap: gap)!
        case .hour:
            return date.nextHourShift!
            
        }
    }
    
    private static func nextPoint(date: Date, points : [Int]) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.init(secondsFromGMT: 0)!
        let minute = calendar.component(.minute, from: date)
        for point in points {
            if minute < point {
                return point
            }
        }
        return 0
    }
    
}
