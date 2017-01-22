//
//  MockNotificationCenter.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/11/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

class MockNotificationCenter : NotificationCenter, NotificationCenterProtocol {
    
    var userInfo: Dictionary<AnyHashable, Any>? = nil
    
    init(center: NotificationCenter) {
    }
    
    override func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object anObject: Any?) {
    }
    
    override func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable : Any]? = nil) {
        self.userInfo = userInfo
    }
    
}

