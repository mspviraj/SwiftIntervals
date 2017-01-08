//
//  DateEnum.swift
//  TimeLapse
//
//  Created by Steven Smith on 1/6/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import SwiftDate

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
    
    static func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return dateFormatter.date(from: dateString)
    }
    
    static func parseIntervalDateString(_ dateString : String) -> (intervalType : DateEnum, date1 : Date?, date2 : Date?) {
        let dates : [String] = dateString.components(separatedBy: ",")
        if dates.count != 2 {
            return (.invalidDate, nil, nil)
        }
        var date1, date2 : Date?
        var type : DateEnum = .between
        
        if dates[0] == "*" {
            date1 = Date()
            type = .fixEnd
        } else {
            if let date = DateEnum.dateFromString(dates[0]) {
                date1 = date
            } else {
                type = .invalidDate
            }
        }
        
        if dates[1] == "*" {
            date2 = Date()
            type = .fixStart
        } else {
            if let date = DateEnum.dateFromString(dates[1]) {
                date2 = date
            } else {
                type = .invalidDate
            }
        }

        return (type, date1, date2)
    }
}
