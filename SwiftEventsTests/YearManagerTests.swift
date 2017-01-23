//
//  YearManagerTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/11/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class YearManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testYearManagerWithBadYears() {
        let notificationCenter = MockNotificationCenter(center: NotificationCenter.default)
        let yearManager = YearManager(notificationCenter: notificationCenter)
        
        yearManager.add(string: "A")
        guard let checkStatus = notificationCenter.userInfo?[CalendarManagerCodes.keyStatus] else {
            XCTAssertTrue(false, "Could not find in dictionary")
            return
        }
        
        let status = checkStatus as! CalendarManagerCodes
        XCTAssertTrue(status == CalendarManagerCodes.badInput, "Status is \(status)")
        
        guard let checkResult = notificationCenter.userInfo?[CalendarManagerCodes.keyResult] else {
            XCTAssertTrue(false,"could not find result")
            return
        }
        
        let result = checkResult as! String
        XCTAssertTrue(result == "", "result is not empty:\(result)")
    }
}
