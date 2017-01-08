//
//  DateIntervals.swift
//  TimeLapse
//
//  Created by Steven Smith on 1/5/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

class DateIntervals {
    
    //Return DateIntervals where the start time is fix (aka not wild card)
    public static func fixStart(startDate : Date, endDate : Date) -> DateIntervals {
        let result = DateIntervals(startTime: startDate, endTime: endDate)
        result.context = DateEnum.compareDate(startDate, toDate: endDate)
        return result;
    }
    
    //Return DateIntervals where the end time is fix (aka not wild card)
    public static func fixEnd(startDate : Date, endDate : Date) -> DateIntervals {
        let result = DateIntervals(startTime: startDate, endTime: endDate)
        result.context = DateEnum.compareDate(endDate, toDate: startDate)
        return result;
    }
    
    private var startTime : Date
    private var endTime : Date
    private var context : DateEnum?
    
    private init(startTime : Date, endTime : Date) {
        if DateEnum.compareDate(startTime, toDate: endTime) == DateEnum.until {
            self.startTime = endTime
            self.endTime = startTime
        } else {
            self.startTime = startTime
            self.endTime = endTime
        }
    }
    
    public func secondInterval() -> (context : DateEnum, seconds: Int) {
        let calendar = NSCalendar.current as NSCalendar
        let flags = NSCalendar.Unit.second
        let components = calendar.components(flags, from: startTime, to: endTime)
        return (self.context!, components.second!)
    }
    
    public func minuteInterval() -> (context : DateEnum, minutes : Int, seconds : Int) {
        let calendar = NSCalendar.current as NSCalendar
        let components = calendar.components([.minute, .second], from: startTime, to: endTime)
        return (self.context!, components.minute!, components.second!)
    }

    public func hourInterval() -> (context : DateEnum,hours : Int, minutes : Int, seconds : Int) {
        let calendar = NSCalendar.current as NSCalendar
        let components = calendar.components([.hour, .minute, .second], from: startTime, to: endTime)
        return (self.context!, components.hour!, components.minute!, components.second!)
    }
    
    public func dayInterval() -> (context : DateEnum,days : Int, hours : Int, minutes : Int, seconds : Int) {
        let calendar = NSCalendar.current as NSCalendar
        let components = calendar.components([.day, .hour, .minute, .second], from: startTime, to: endTime)
        return (self.context!, components.day!, components.hour!, components.minute!, components.second!)
    }
    
    public func monthInterval() -> (context : DateEnum,months : Int, days : Int, hours : Int, minutes : Int, seconds : Int) {
        let calendar = NSCalendar.current as NSCalendar
        let components = calendar.components([.month, .day, .hour, .minute, .second], from: startTime, to: endTime)
        return (self.context!, components.month!, components.day!, components.hour!, components.minute!, components.second!)
    }
    
    public func yearInterval() -> (context : DateEnum,years : Int, months : Int, days : Int, hours : Int, minutes : Int, seconds : Int) {
        let calendar = NSCalendar.current as NSCalendar
        let components = calendar.components([.year, .month, .day, .hour, .minute, .second], from: startTime, to: endTime)
        return (self.context!, components.year!, components.month!, components.day!, components.hour!, components.minute!, components.second!)
    }

}
