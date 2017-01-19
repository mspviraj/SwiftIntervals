//
//  TimeManager.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/17/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

enum TimeEnum : String {
    case asAM, asPM
}

class TimeManager {
    
    let timeManager : Notification.Name = Notification.Name(rawValue: "TimeManager")
    
    var result : String {
        get {
            return h1 + h2 + ":" + m1 + m2
        }
    }

    private var h1 = "0"
    private var h2 = "0"
    private var m1 = "0"
    private var m2 = "0"
    private var position = 0
    private var status = CalendarManagerCodes.building
    
    private let notificationCenter : NotificationCenter
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    private func broadcast(reason: CalendarManagerCodes, result: String, digit: String) -> (CalendarManagerCodes, String) {
        self.status = reason
        let userInfo = [CalendarManagerCodes.keyStatus : reason, CalendarManagerCodes.keyResult: result, CalendarManagerCodes.keyBuild : digit] as [CalendarManagerCodes : Any]
        self.notificationCenter.post(name: self.timeManager, object: nil, userInfo: userInfo)
        return (reason, result)
    }
    
    private func ripple(digit: String) {
        h1 = h2
        h2 = m1
        m1 = m2
        m2 = digit
        position += 1
    }
    
    func add(digit: String) -> (CalendarManagerCodes, String) {
        guard digit >= "0" && digit <= "9" && self.status != .completed else {
            return broadcast(reason: .badInput, result: self.result, digit: digit)
        }
        switch(position) {
        case 0:
            return parseM2(digit: digit)
        case 1:
            return parseM1(digit: digit)
        case 2:
            return parseH2(digit: digit)
        case 3:
            return parseH1(digit: digit)
        default:
            return broadcast(reason: .badInput, result: self.result, digit: digit)
        }
    }
    
    func adjust(clockType: TimeEnum) -> (CalendarManagerCodes, String) {
        switch clockType {
        case .asAM:
            return setAsAM()
        case .asPM:
            return setAsPM()
        }
    }
    
    private func setAsAM() -> (CalendarManagerCodes, String) {
        let hours = Int(h1+h2)!
        switch hours {
        case 12:
            h1 = "0"
            h2 = "0"
        case 13...23:
            return broadcast(reason: CalendarManagerCodes.badInput, result: self.result, digit: TimeEnum.asAM.rawValue)
        default:
            break
        }
        return broadcast(reason: CalendarManagerCodes.building, result: self.result, digit: TimeEnum.asAM.rawValue)
    }
    
    private func setAsPM() -> (CalendarManagerCodes, String) {
        var hours = Int(h1+h2)!
        if hours == 0 {
            return broadcast(reason: .building, result: self.result, digit: TimeEnum.asPM.rawValue)
        }
        if hours < 12 {
            hours += 12
        }
        h1 = String(hours / 10)
        h2 = String(hours % 10)
        return broadcast(reason: .building, result: self.result, digit: TimeEnum.asPM.rawValue)
    }
    
    
    private func parseM2(digit: String) -> (CalendarManagerCodes, String) {
        if digit == "0" {
            return (.building, self.result)
        }
        ripple(digit: digit)
        return broadcast(reason: .building, result: self.result, digit: digit)
    }
    
    private func parseM1(digit: String) -> (CalendarManagerCodes, String) {
        if self.m2 >= "6" && self.m2 <= "9" {
            guard digit <= "5" else {
                return broadcast(reason: .badInput, result: self.result, digit: digit)
            }
            ripple(digit: digit)
            return broadcast(reason: .incomplete, result: self.result, digit: digit)
        }
        
        if self.m2 >= "3" && digit >= "6" {
            ripple(digit: digit)
            return broadcast(reason: .completed, result: self.result, digit: digit)
        }
        
        ripple(digit: digit)
        return broadcast(reason: .building, result: self.result, digit: digit)
    }
    
    private func parseH2(digit: String) -> (CalendarManagerCodes, String) {
        if m1 == "1" && (m2 >= "6" && m2 <= "9") {
            guard digit <= "5" else {
                return broadcast(reason: .badInput, result: self.result, digit: digit)
            }
            ripple(digit: digit)
            return broadcast(reason: .incomplete, result: self.result, digit: digit)
        }
        if m1 >= "3" {
            ripple(digit: digit)
            return broadcast(reason: .completed, result: self.result, digit: digit)
        }
        
        if m1 == "2" && (m2 == "4" || m2 == "5") {
            ripple(digit: digit)
            return broadcast(reason: .completed, result: self.result, digit: digit)
        }
        
        if m1 == "2" && digit >= "6" {
            ripple(digit: digit)
            return broadcast(reason: .completed, result: self.result, digit: digit)
        }
        
        if m1 >= "3" && m1 <= "9" {
            ripple(digit: digit)
            return broadcast(reason: .completed, result: self.result, digit: digit)
        }
        
        ripple(digit: digit)
        return broadcast(reason: .building, result: self.result, digit: digit)
    }
    
    private func parseH1(digit: String) -> (CalendarManagerCodes, String) {
        guard h2 == "1" || h2 == "2" else {
            return broadcast(reason: .badInput, result: self.result, digit: digit)
        }
        ripple(digit: digit)
        return broadcast(reason: .completed, result: self.result, digit: digit)
    }
}
