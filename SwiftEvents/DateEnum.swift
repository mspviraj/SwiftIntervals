//
//  DateEnum.swift
//  TimeLapse
//
//  Created by Steven Smith on 1/6/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import SwiftDate

enum UpdateInterval : String {
    case second, minute, hour, day, month, year
    
    static func from(string: String) -> UpdateInterval {
        switch string {
        case second.rawValue:
            return second
        case minute.rawValue:
            return minute
        case hour.rawValue:
            return hour
        case day.rawValue:
            return day
        case month.rawValue:
            return month
        case year.rawValue:
            return year
        default:
            assertionFailure("Invalid enum")
        }
        return minute
    }
}

enum DateEnum {
    case since, now, until, between
    case fixStart, fixEnd
    case invalidDate

    static func compareDate(_  from: Date, toDate: Date) -> DateEnum{
        switch(from.compare(toDate)) {
        case .orderedAscending:
            return .since
        case .orderedSame:
            return .now
        case .orderedDescending:
            return .until
        }
    }
    
    static let utcFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    static let dateWildCard = "*"
    
    static func stringFrom(date : Date?) -> String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcFormat
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return dateFormatter.string(from: date)
    }
    
    static func dateFrom(string: String?) -> Date? {
        guard let string = string else {
            return nil
        }
        if string == dateWildCard {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcFormat
        return dateFormatter.date(from: string)
    }
    
}
