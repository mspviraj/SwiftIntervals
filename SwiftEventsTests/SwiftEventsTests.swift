//
//  SwiftEventsTests.swift
//  SwiftEventsTests
//
//  Created by Steven Smith on 1/7/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
@testable import SwiftEvents
@testable import SwiftDate

class SwiftEventsTests: XCTestCase {
    
    fileprivate var past : Date = Date()
    fileprivate var present : Date = Date()
    fileprivate var future : Date = Date()
    fileprivate let birthday : String = "1960-12-19T20:56:00+00:00"
//    fileprivate let sinceBirthday = "1960-12-19T20:56:00+00:00,*"
//    fileprivate let birthdayGap = "1960-12-19T20:56:00+00:00,2017-12-19T20:56:00+00:00"
//    fileprivate let badDate = "1960-12-19:20:56:00+00:00,2017-12-19T20:56:00+00:00"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        past = dateFormatter.date(from: "1960-12-19 15:36:01") ?? Date()
        present = dateFormatter.date(from: "2017-01-06 11:00:00") ?? Date()
        future = dateFormatter.date(from: "2018-01-06 11:00:00") ?? Date()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFixStartPastNow() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dateInterval : DateIntervals = DateIntervals.fixStart(startDate: past, endDate: present)
        let K = dateInterval.secondInterval()
        assert(K.context == DateEnum.since, "K:\(K.context)")
        assert(K.seconds == 1768764239, "Seconds:\(K.seconds)")
    }
    
    func testFixStartNowPast() {
        let dateInterval : DateIntervals = DateIntervals.fixStart(startDate: present, endDate: past)
        let K = dateInterval.secondInterval()
        print("Context:\(K.context)")
        assert(K.context == DateEnum.until, "K:\(K.context)")
        assert(K.seconds == 1768764239, "Seconds:\(K.seconds)")
    }
    
    func testFixStartNowFuture() {
        let dateInterval : DateIntervals = DateIntervals.fixStart(startDate: present, endDate: future)
        let K = dateInterval.secondInterval()
        assert(K.context == DateEnum.since, "K:\(K.context)")
        assert(K.seconds == 31536000, "Seconds:\(K.seconds)")
    }
    
    func testBirthDay() {
        let dateInterval : DateIntervals = DateIntervals.fixStart(startDate: past, endDate: present)
        let bDate = dateInterval.yearInterval()
        assert(bDate.years == 56, "Years:\(bDate.years)")
        assert(bDate.days == 17, "Days:\(bDate.days)")
        assert(bDate.hours == 19, "Hours:\(bDate.hours)")
        assert(bDate.minutes == 23, "Minutes:\(bDate.minutes)")
        assert(bDate.seconds == 59, "Seconds:\(bDate.seconds)")
        
    }
    
    func testDate() {
        let m = DateInRegion()
        print("m=\(m)")
        let seaTac = TimeZoneName.americaLosAngeles
        print("seaTac=\(seaTac)")
        let seattle = Region(tz: seaTac, cal: CalendarName.gregorian, loc: LocaleName.english)
        print("seattle=\(seattle)")
        
        let date1 = try! DateInRegion(string: "1960-12-19T20:56:00+00:00", format: .custom("yyyy-MM-dd'T'HH:mm:ssZ"), fromRegion: seattle)
        print("date1=\(date1)")
        
        let newYork = Region(tz: TimeZoneName.americaNewYork, cal: CalendarName.gregorian, loc: LocaleName.english)
        print("newYork=\(newYork)")
        let date2 = try! DateInRegion(string: "1960-12-19T20:56:00+00:00", format: .custom("yyyy-MM-dd'T'HH:mm:ssZ"), fromRegion: newYork)
        print("date2=\(date2)")
        
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    //    
}
