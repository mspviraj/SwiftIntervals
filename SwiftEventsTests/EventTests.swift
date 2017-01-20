//
//  EventTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/9/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
import Gloss

class EventTests: XCTestCase {
    
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
    
    func testEventInit() {
    }
    
    func testInitEvent() {
        let now = Date()
        let event = Event()
        guard let nowString = DateEnum.stringFrom(date: now) else {
            XCTAssert(false, "nowString returned nil")
            return
        }
        guard let eventStart = DateEnum.stringFrom(date: event.startTime) else {
            XCTAssert(false, "eventStart returned nil")
            return
        }
        XCTAssertEqual(nowString, eventStart)
    }
    
    func testInitJSON() {
        let now = Date()
        let event = Event()
        guard let nowString = DateEnum.stringFrom(date: now) else {
            XCTAssert(false, "nowString returned nil")
            return
        }
        guard let eventStart = DateEnum.stringFrom(date: event.startTime) else {
            XCTAssert(false, "eventStart returned nil")
            return
        }
        XCTAssertEqual(nowString, eventStart)
        let json : JSON = event.toJSON()!
        print("json:\(json)")
        XCTAssertNotNil(json)
        let event2 = Event(json: json)
        XCTAssertNotNil(event2)
        
        let jsonStart = DateEnum.stringFrom(date: event.startTime)
        let jsonFinish = DateEnum.stringFrom(date: event.endTime)
        XCTAssertEqual(jsonStart, nowString)
        XCTAssertEqual(jsonFinish, nowString)
        
    }
    
    func testInitWithStart() {

        let now = Date()
        let nowString = DateEnum.stringFrom(date: now)
        let event = Event("My Event", startTime: birthday)
        let endString = DateEnum.stringFrom(date: event?.endTime)
        XCTAssertEqual(nowString, endString)
        let birthDate = DateEnum.dateFrom(string: birthday)
        XCTAssertEqual(birthDate, event?.startTime)
        
    }
    
    func testInterval() {
        let event = Event()
        let interval = event.refreshInterval
        XCTAssertEqual(interval, UpdateInterval.minute)
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
