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
    
    override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        self.notificationCenter.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    override func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        self.notificationCenter.post(name: aName, object: anObject, userInfo: aUserInfo)
    }
}

class TestNotificationCenter : NotificationCenter, NotificationCenterProtocol {
    
    var observers: Dictionary<Notification.Name, Any> = [:]
    
    init(center: NotificationCenter) {
    }
    
    override func addObserver(_ observer: Any, selector aSelector: Selector, name: NSNotification.Name?, object anObject: Any?) {
        guard let name = name else {
            return
        }
        self.observers[name] = name
    }
    
    override func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable : Any]? = nil) {
        if  userInfo != nil {
            self.observers[name] = userInfo
        } else {
            self.observers[name] = "nil"
        }
    }
   
}

