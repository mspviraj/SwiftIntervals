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
        case 0:
            return Date()
        case 1:
            return Gregorian.calendar.nextDate(after: self, matching: DateComponents(second: 0), matchingPolicy: .nextTime)
        case 60:
            return Gregorian.calendar.nextDate(after: self, matching: DateComponents(minute: 0), matchingPolicy: .nextTime)
        default:
            return Gregorian.calendar.nextDate(after: self, matching: DateComponents(minute: gap), matchingPolicy: .nextTime)
        }
    }
}

struct NextTime {
    static func with(date: Date, interval : Int = 1) -> Date {
        
        switch interval {
        case 0:
            return date.nextWith(gap: 0)!
        case 1:
            return date.nextWith(gap: 1)!

        case 5:
            let gap = nextPoint(date: date, points:[5,10,15,20,25,30,35,40,45,50,55,60])
            return date.nextWith(gap: gap)!
        case 15:
            let gap = nextPoint(date: date, points:[15,30,45,60])
            return date.nextWith(gap: gap)!
        case 30:
            let gap = nextPoint(date: date, points:[30,60])
            return date.nextWith(gap: gap)!
        case 60:
            return date.nextHourShift!
        default:
            return date.nextWith(gap: 0)!
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
