//
//  DateIntervals.swift
//  TimeLapse
//
//  Created by Steven Smith on 1/5/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

//What kind of interval information is displayed
enum DisplayInterval : String {
    case second
    case minute
    case hour
    case day
    case month
    case year
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
            return "\(pretty(number: result.minute!))min \(pretty(number:result.second!))sec"
        case .hour:
            return "\(pretty(number: result.hour!))hr " + String(format: "%02dm %02ds", result.minute!, result.second!)
        case .day:
            return "\(pretty(number: result.day!))dy " + String(format: "%02d:%02d:%02d", result.hour!, result.minute!, result.second!)
        case .month:
            return "\(pretty(number: result.month!))mth " + String(format: "%ddy %02d:%02d:%02d", result.day!, result.hour!, result.minute!, result.second!)
        case .year:
            return "\(pretty(number: result.year!))yr " + String(format: "%dmth %ddy %02d:%02d:%02d", result.month!, result.day!, result.hour!, result.minute!, result.second!)
      }
    }
    
    private func pretty(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: abs(number))!
    }
}
