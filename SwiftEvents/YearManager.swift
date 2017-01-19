//
//  File.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/11/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

class YearManager {
    
    let yearManager :Notification.Name = Notification.Name(rawValue: "YearManager")
    
    private let notificationCenter : NotificationCenter
    private var theYear = ""
    var year : String {
        return theYear
    }
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    private func broadcast(reason: CalendarManagerCodes, result: String) {
        let userInfo = [CalendarManagerCodes.keyStatus : reason, CalendarManagerCodes.keyResult: result] as [CalendarManagerCodes : Any]
        self.notificationCenter.post(name: yearManager, object: nil, userInfo: userInfo)
    }
    
    func add(string: String) {
        guard (string >= "0" && string <= "9") || (string == "19" || string == "20") else {
            broadcast(reason: CalendarManagerCodes.badInput, result: theYear)
            return
        }
        
        theYear += string
        if theYear >= "3" {
            theYear = ""
            broadcast(reason: CalendarManagerCodes.badInput, result: theYear)
            return
        }
        
        if Int(theYear)! >= 1000 {
            broadcast(reason: CalendarManagerCodes.completed, result: theYear)
            return
        }
        
        broadcast(reason: CalendarManagerCodes.building, result: theYear)
    }
}
