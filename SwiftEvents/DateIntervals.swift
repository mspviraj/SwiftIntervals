//
//  DateIntervals.swift
//  TimeLapse
//
//  Created by Steven Smith on 1/5/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

enum RefreshRates {
    case second
    case minute
    case fiveMinutes
    case fifteenMinutes
    case thirtyMinutes
    case hour
    func asSeconds() -> Int {
        switch self {
        case .second:
            return 1
        case .minute:
            return 60
        case .fiveMinutes:
            return 5 * 60
        case .fifteenMinutes:
            return 15 * 60
        case .thirtyMinutes:
            return 30 * 60
        case .hour:
            return 60 * 60
        }
    }
    static func from(seconds: Int) -> RefreshRates? {
        switch(seconds) {
        case 1:
            return RefreshRates.second
        case 60:
            return RefreshRates.minute
        case 300:
            return RefreshRates.fiveMinutes
        case 900:
            return RefreshRates.fifteenMinutes
        case 1800:
            return RefreshRates.thirtyMinutes
        case 3600:
            return RefreshRates.hour
        default:
            return nil
        }
    }
}
enum DisplayInterval : String {
    case second
    case minute
    case hour
    case day
    case month
    case year
    case progressive
    static func from(string: String) -> DisplayInterval {
        switch string {
        case "second":
            return .second
        case "minute":
            return .minute
        case "hour":
            return .hour
        case "day":
            return .day
        case "month":
            return .month
        case "year":
            return .year
        case "progressive":
            return .progressive
        default:
            return .second
        }
    }
}

struct DateIntervals {
    public static func setFor(startDate: String, endDate: String) -> DateIntervals? {
        guard let startTime = DateEnum.dateFrom(string: startDate) else {
            return nil
        }
        
        guard let endTime = DateEnum.dateFrom(string: endDate) else {
            return nil
        }
        
        return DateIntervals(startTime: startTime, endTime: endTime)
    }
    
    
    private var intervals = [DisplayInterval : DateComponents]()
    private var formats = [DisplayInterval : String]()
    
    private init(startTime: Date, endTime: Date) {
        let calendar = NSCalendar.current as NSCalendar
        intervals[.second] = calendar.components(.second, from: startTime, to: endTime)
        intervals[.minute] = calendar.components([.second, .minute], from: startTime, to: endTime)
        intervals[.hour] = calendar.components([.second, .minute, .hour], from: startTime, to: endTime)
        intervals[.day] = calendar.components([.second, .minute, .hour, .day], from: startTime, to: endTime)
        intervals[.month] = calendar.components([.second, .minute, .hour, .day, .month], from: startTime, to: endTime)
        intervals[.year] = calendar.components([.second, .minute, .hour, .day, .month, .year], from: startTime, to: endTime)
        intervals[.progressive] = intervals[.year]
    }
    
    public func publish(interval : DisplayInterval) -> String {
        guard let result = intervals[interval] else {
            assertionFailure("Could not find interval \(interval)")
            return ""
        }
        
        switch interval {
        case .second:
            return "seconds:\(pretty(number: result.second!))"
        case .minute:
            return "min:\(pretty(number: result.minute!)) sec:\(pretty(number:result.second!))"
        case .hour:
            return "hr:\(pretty(number: result.hour!)) " + String(format: "min:%02d sec:%02d", result.minute!, result.second!)
        case .day:
            return "day:\(pretty(number: result.day!)) " + String(format: "%02d:%02d:%02d", result.hour!, result.minute!, result.second!)
        case .month:
            return "month:\(pretty(number: result.month!)) " + String(format: "day:%d %02d:%02d:%02d", result.day!, result.hour!, result.minute!, result.second!)
        case .year:
            return "year:\(pretty(number: result.year!)) " + String(format: "month:%d day:%d %02d:%02d:%02d", result.month!, result.day!, result.hour!, result.minute!, result.second!)
        case .progressive:
            if result.year! > 0 { return publish(interval: .year) }
            if result.month! > 0 { return publish(interval: .month) }
            if result.day! > 0 { return publish(interval: .day) }
            if result.hour! > 0 { return publish(interval: .hour) }
            if result.minute! > 0 { return publish(interval: .minute) }
            return publish(interval: .second)
      }
    }
    
    private func pretty(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: abs(number))!
    }
}
