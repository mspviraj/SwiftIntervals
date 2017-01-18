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
        guard let start = DateEnum.dateFrom(string: birthday) else {
            XCTAssert(false, "Starting date returned nil")
            return
        }
        guard let finish = DateEnum.dateFrom(string: future) else {
            XCTAssert(false, "Finish date returned nil")
            return
        }
        let interval = DateIntervals.fixStart(startDate: start, endDate: finish)
        let secondInterval = interval.secondInterval()
        XCTAssertEqual(secondInterval.context, DateEnum.since, "Context returned is \(secondInterval.context)")
        XCTAssertEqual(secondInterval.seconds, 1768348800, "Seconds returned:\(secondInterval.seconds)")
    }
    
    func testMinuteInterval() {
        guard let start = DateEnum.dateFrom(string: birthday) else {
            XCTAssert(false, "Starting date returned nil")
            return
        }
        guard let finish = DateEnum.dateFrom(string: future) else {
            XCTAssert(false, "Finish date returned nil")
            return
        }
        let interval = DateIntervals.fixStart(startDate: start, endDate: finish)
        let secondInterval = interval.minuteInterval()
        XCTAssertEqual(secondInterval.context, DateEnum.since, "Context returned is \(secondInterval.context)")
        XCTAssertEqual(secondInterval.minutes, 29472480, "Minutes returned:\(secondInterval.minutes)")
        XCTAssertEqual(secondInterval.seconds, 0, "Seconds returned:\(secondInterval.seconds)")

    }
    
    func testHourInterval() {
        guard let start = DateEnum.dateFrom(string: birthday) else {
            XCTAssert(false, "Starting date returned nil")
            return
        }
        guard let finish = DateEnum.dateFrom(string: future) else {
            XCTAssert(false, "Finish date returned nil")
            return
        }
        let interval = DateIntervals.fixStart(startDate: start, endDate: finish)
        let hourInterval = interval.hourInterval()
        XCTAssertEqual(hourInterval.context, DateEnum.since, "Context returned is \(hourInterval.context)")
        XCTAssertEqual(hourInterval.hours, 491208, "Hours returned \(hourInterval.hours)")
        XCTAssertEqual(hourInterval.minutes, 0, "Minutes returned:\(hourInterval.minutes)")
        XCTAssertEqual(hourInterval.seconds, 0, "Seconds returned:\(hourInterval.seconds)")
 
    }
    
    func testDayInterval() {
        guard let start = DateEnum.dateFrom(string: birthday) else {
            XCTAssert(false, "Starting date returned nil")
            return
        }
        guard let finish = DateEnum.dateFrom(string: future) else {
            XCTAssert(false, "Finish date returned nil")
            return
        }
        let interval = DateIntervals.fixStart(startDate: start, endDate: finish)
        let dayInterval = interval.dayInterval()
        XCTAssertEqual(dayInterval.context, DateEnum.since, "Context returned is \(dayInterval.context)")
        XCTAssertEqual(dayInterval.days, 20467, "Days returned \(dayInterval.days)")
        XCTAssertEqual(dayInterval.hours, 0, "Hours returned \(dayInterval.hours)")
        XCTAssertEqual(dayInterval.minutes, 0, "Minutes returned:\(dayInterval.minutes)")
        XCTAssertEqual(dayInterval.seconds, 0, "Seconds returned:\(dayInterval.seconds)")
 
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMonthInterval() {
        guard let start = DateEnum.dateFrom(string: birthday) else {
            XCTAssert(false, "Starting date returned nil")
            return
        }
        guard let finish = DateEnum.dateFrom(string: future) else {
            XCTAssert(false, "Finish date returned nil")
            return
        }
        let interval = DateIntervals.fixStart(startDate: start, endDate: finish)
        let monthInterval = interval.monthInterval()
        XCTAssertEqual(monthInterval.context, DateEnum.since, "Context returned is \(monthInterval.context)")
        XCTAssertEqual(monthInterval.months, 672, "Months returned \(monthInterval.months)")
        XCTAssertEqual(monthInterval.days, 13, "Days returned \(monthInterval.days)")
        XCTAssertEqual(monthInterval.hours, 0, "Hours returned \(monthInterval.hours)")
        XCTAssertEqual(monthInterval.minutes, 0, "Minutes returned:\(monthInterval.minutes)")
        XCTAssertEqual(monthInterval.seconds, 0, "Seconds returned:\(monthInterval.seconds)")
    }
    
    func testYearInterval() {
        guard let start = DateEnum.dateFrom(string: birthday) else {
            XCTAssert(false, "Starting date returned nil")
            return
        }
        guard let finish = DateEnum.dateFrom(string: future) else {
            XCTAssert(false, "Finish date returned nil")
            return
        }
        let interval = DateIntervals.fixStart(startDate: start, endDate: finish)
        let yearInterval = interval.yearInterval()
        XCTAssertEqual(yearInterval.context, DateEnum.since, "Context returned is \(yearInterval.context)")
        XCTAssertEqual(yearInterval.years, 56, "Years returned \(yearInterval.years)")
        XCTAssertEqual(yearInterval.months, 0, "Months returned \(yearInterval.months)")
        XCTAssertEqual(yearInterval.days, 13, "Days returned \(yearInterval.days)")
        XCTAssertEqual(yearInterval.hours, 0, "Hours returned \(yearInterval.hours)")
        XCTAssertEqual(yearInterval.minutes, 0, "Minutes returned:\(yearInterval.minutes)")
        XCTAssertEqual(yearInterval.seconds, 0, "Seconds returned:\(yearInterval.seconds)")
 
    }
}
