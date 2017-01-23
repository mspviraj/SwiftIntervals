//
//  DateIntervalsTest.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/17/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class DateIntervalsTest: XCTestCase {
    fileprivate let birthday : String = "1960-12-19T20:56:00Z"
    fileprivate let future   : String = "2017-01-01T20:56:00Z"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSecondInterval() {
        guard let interval = DateIntervals.setFor(startDate: birthday, endDate: future) else {
            XCTAssert(false, "interval returned nil")
            return
        }
        
        
        let secondInterval = interval.publish(interval: .second)
        XCTAssertEqual(secondInterval, "seconds:1,768,348,800")
    }
    
    func testMinuteInterval() {
        guard let interval = DateIntervals.setFor(startDate: birthday, endDate: future) else {
            XCTAssert(false, "interval returned nil")
            return
        }
        
        
        let minute = interval.publish(interval: .minute)
        XCTAssertEqual(minute, "min:29,472,480 sec:0")

    }
    
    func testMonthInterval() {
        guard let interval = DateIntervals.setFor(startDate: birthday, endDate: future) else {
            XCTAssert(false, "interval returned nil")
            return
        }
        
        let month = interval.publish(interval: .month)
        XCTAssertEqual(month, "month:672 day:13 00:00:00")
        
    }
    
    func testYearInterval() {
        guard let interval = DateIntervals.setFor(startDate: birthday, endDate: future) else {
            XCTAssert(false, "interval returned nil")
            return
        }
        
        let yearInterval = interval.publish(interval: .year)
        XCTAssertEqual(yearInterval, "year:56 month:0 day:13 00:00:00")
    }
}
