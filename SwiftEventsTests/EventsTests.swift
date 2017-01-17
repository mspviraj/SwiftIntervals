//
//  EventsTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/8/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class EventsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        guard let event = Event("Using this event", startTime: "*", endTime: "*") else {
            assert(false, "Event is nil")
            return
        }
        print(event)
    }
}
