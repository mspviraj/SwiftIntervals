//
//  TimeManagerTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/18/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest


class TimeManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBadInput() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        let test = timeManager.add(digit: "X")
        XCTAssertEqual(test.0, CalendarManagerCodes.badInput)
        
    }
    
    func testBadNumbers() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        var test = timeManager.add(digit: "9")
        XCTAssertEqual(test.0, CalendarManagerCodes.building)
        test = timeManager.add(digit: "9")
        XCTAssertEqual(test.0, CalendarManagerCodes.badInput)
        XCTAssertEqual(test.1, "00:09")
    }
    
    func testPartial() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        var test = timeManager.add(digit: "9")
        XCTAssertEqual(test.0, CalendarManagerCodes.building)
        test = timeManager.add(digit: "5")
        XCTAssertEqual(test.0, CalendarManagerCodes.incomplete)
        XCTAssertEqual(test.1, "00:95")
        
        test = timeManager.add(digit: "7")
        XCTAssertEqual(test.0, CalendarManagerCodes.completed)
        XCTAssertEqual(test.1, "09:57")
    }
    
    func testPastNoonGood() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        var test = timeManager.add(digit: "2")
        test = timeManager.add(digit: "3")
        test = timeManager.add(digit: "5")
        XCTAssertEqual(test.0, CalendarManagerCodes.building)
        XCTAssertEqual(test.1, "02:35")
        
        test = timeManager.add(digit: "9")
        XCTAssertEqual(test.0, CalendarManagerCodes.completed)
        XCTAssertEqual(test.1, "23:59")
    }
    
    func testPastBeforeNoon() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        var test = timeManager.add(digit: "2")
        test = timeManager.add(digit: "3")
        test = timeManager.add(digit: "7")
        XCTAssertEqual(test.0, CalendarManagerCodes.completed)
        XCTAssertEqual(test.1, "02:37")
    }
    
    func testPastNoon() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        _ = timeManager.add(digit: "1")
        _ = timeManager.add(digit: "4")
        var test = timeManager.add(digit: "5")
        XCTAssertEqual(test.0, .building)
        XCTAssertEqual(test.1, "01:45")
        test = timeManager.add(digit: "9")
        XCTAssertEqual(test.0, .completed)
        XCTAssertEqual(test.1, "14:59")
    }
    
    func testSmall() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        _ = timeManager.add(digit: "4")
        let test = timeManager.add(digit: "9")
        XCTAssertEqual(test.0, .completed)
        XCTAssertEqual(test.1, "00:49")
    }
    
    func testNearMidnight() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        var test = timeManager.add(digit: "2")
        test = timeManager.add(digit: "3")
        test = timeManager.add(digit: "5")
        XCTAssertEqual(test.0, .building)
        XCTAssertEqual(test.1, "02:35")
        test = timeManager.add(digit: "9")
        XCTAssertEqual(test.0, .completed)
        XCTAssertEqual(test.1, "23:59")
    }
    
    func testAM() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        _ = timeManager.add(digit: "1")
        _ = timeManager.add(digit: "2")
        _ = timeManager.add(digit: "3")
        var test = timeManager.add(digit: "4")
        XCTAssertEqual(test.1, "12:34")
        test = timeManager.adjust(clockType: .asAM)
        XCTAssertEqual(test.1, "00:34")
    }
    
    func testPM() {
        let timeManager = TimeManager(notificationCenter: MockNotificationCenter(center: NotificationCenter.default))
        _ = timeManager.add(digit: "5")
        _ = timeManager.add(digit: "3")
        var test = timeManager.add(digit: "4")
        XCTAssertEqual(test.1, "05:34")
        test = timeManager.adjust(clockType: .asPM)
        XCTAssertEqual(test.1, "17:34")

    }
}
