//
//  EventTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/9/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class EventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEvent() {
        let event = Event("First", startTime: "*", endTime: "*")
        print(event)
        assert(event.endTime != nil, "Event is nil")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testEvents() {
        let event = Event("First", startTime:"*", endTime:"*")
        assert(event.endTime != nil, "Event is nil")
        let events = Events(event: event)
        let json = events?.toJSON()
        print(json!)
        assert(json?.count != 0, "count:\(json?.count)")
        let jsonString = events?.toString()
        assert(jsonString != nil, "JsonString nil");
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
