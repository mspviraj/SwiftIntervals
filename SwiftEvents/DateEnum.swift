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
    
//    static func parseIntervalDateString(_ dateString : String) -> (intervalType : DateEnum, date1 : Date?, date2 : Date?) {
//        let dates : [String] = dateString.components(separatedBy: ",")
//        if dates.count != 2 {
//            return (.invalidDate, nil, nil)
//        }
//        
//        if dates[0] == dateWildCard {
//            guard let date = DateEnum.dateFromString(dates[1]) else {
//                return (.invalidDate, nil, nil)
//            }
//            return (.fixEnd, Date(), date)
//        }
//        
//        if (dates[1] == dateWildCard) {
//            guard let date = DateEnum.dateFromString(dates[0]) else {
//                return (.invalidDate, nil, nil)
//            }
//            return (.fixStart, date, Date())
//        }
//        
//        guard let startDate = DateEnum.dateFromString(dates[0]), let endDate = DateEnum.dateFromString(dates[1]) else {
//            return (.invalidDate, nil, nil)
//        }
//        
//        return (.between, startDate, endDate)
//
//    }
}
