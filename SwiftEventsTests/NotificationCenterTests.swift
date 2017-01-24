//
//  NotificationCenterTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/10/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class NotificationCenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotificationCenterSetup() {
        let name = Notification.Name("Here")
        
        let notificationCenter = MockNotificationCenter(center: NotificationCenter.default)
        notificationCenter.post(name: name, object: nil, userInfo: ["result" : "value"])
        
        guard let result = notificationCenter.userInfo else {
            assertionFailure("result is nil")
            return
        }
        
        assert(result.count == 1, "Dictionary has \(result.count)")
        print("result: \(result)")
    
    }    
}
