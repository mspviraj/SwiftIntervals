//
//  MyNotificationCenter.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/10/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

protocol NotificationCenterProtocol {
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
    func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]?)
}

class MyNotificationCenter : NotificationCenter,  NotificationCenterProtocol {
    
    let notificationCenter : NotificationCenter
    
    init(center: NotificationCenter) {
        self.notificationCenter = center
    }
    
    override func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?) {
        self.notificationCenter.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    override func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable : Any]? = nil) {
        self.notificationCenter.post(name: name, object: object, userInfo: userInfo)
    }
}

