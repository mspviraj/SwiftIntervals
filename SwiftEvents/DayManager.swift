//
//  DayManager.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/12/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

class DayManager {
    let notificationCenterName = Notification.Name("DayManager")
    
    private let minDaysInMonth = 28
    private let maxDaysInMonth = 31
    private let notificationCenter : NotificationCenter
    private var day = 0
    private let maxDay : Int
    private let numberFormatter : NumberFormatter = NumberFormatter()
    
    init?(notificationCenter: NotificationCenter, maxDay: Int) {
        self.maxDay = maxDay
        self.notificationCenter = notificationCenter
        self.numberFormatter.minimumIntegerDigits = 2
        guard maxDay >= minDaysInMonth && maxDay <= maxDaysInMonth else {
            return nil
        }
    }
    
    private func broadcast(reason: CalendarManagerCodes, result: Int, dayValue: Int) {
        self.day = dayValue
        
        let resultString = numberFormatter.string(for: result)!
        let dayString = numberFormatter.string(for: dayValue)!
        
        let userInfo = [CalendarManagerCodes.keyStatus : reason,
                        CalendarManagerCodes.keyResult: resultString,
                        CalendarManagerCodes.keyBuild: dayString]
            as [CalendarManagerCodes : Any]
        
        self.notificationCenter.post(name: self.notificationCenterName, object: nil, userInfo: userInfo)
    }
    
    func add(string: String) {
        guard var value = Int(string) else {
            broadcast(reason: .badInput, result: -1, dayValue: self.day)
            return
        }
        
        guard (value >= 0 && value <= 10) || (value == 20) || (value == 30) else {
            broadcast(reason: .badInput, result: value, dayValue: self.day)
            return
        }
        
        value = (day == 0) || (day == 10) || (day == 20) || (day == 30) ? (day + value) : (day * 10 + value)
        
        guard value >= 1 && value <= self.maxDay else {
            broadcast(reason: .badInput, result: value, dayValue: self.day)
            return
        }
        
        switch(value) {
        case 1...3:
            broadcast(reason: .building, result: value, dayValue:  value)
        case 4...9:
            broadcast(reason: .completed, result: value, dayValue: value)
        case 10:
            broadcast(reason: .building, result: value, dayValue: value)
        case 11...19:
            broadcast(reason: .completed, result: value, dayValue: value)
        case 20:
            broadcast(reason: .building, result: value, dayValue: value)
        case 21...29:
            broadcast(reason: .completed, result: value, dayValue: value)
        case 30:
            broadcast(reason: .building, result: value, dayValue: value)
        case 31:
            broadcast(reason: .completed, result: value, dayValue: value)
        default:
            broadcast(reason: .badInput, result: value, dayValue:  self.day)
        }
    }
}
