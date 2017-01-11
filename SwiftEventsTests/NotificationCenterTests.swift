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
        
        let notificationCenter = TestNotificationCenter(center: NotificationCenter.default)
        let dict = notificationCenter.observers
        assert(dict.count == 0, "Dictionary has \(dict.count) entries")
        
        print("\(dict)")
        
        notificationCenter.addObserver(self, selector:#selector(testNotificationCenterSetup), name: name, object: nil)
        let observer = notificationCenter.observers
        assert(observer.count == 1, "Dictionary has \(dict.count) entries")
        if let notification : Notification.Name = observer[name] as! Notification.Name? {
            print("\(notification)")
            assert(notification == name, "name:\(name)")
        }
        
        notificationCenter.post(name: name, object: nil, userInfo:["result" : "value"])
        let result = notificationCenter.observers
        assert(result.count == 1, "Dictionary has \(result.count)")
        print("\(result)")
    
        if let answer = result[name] as? Dictionary<String,String> {
            print("answer:\(answer)")
        } else {
            assertionFailure("answer is not a dictionary")
        }
    }
    
        func testPerformanceExample() {
            // This is an example of a performance test case.
            self.measure {
                // Put the code you want to measure the time of here.
            }
        }
        
}
