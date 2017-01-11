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
    
    func testEventInit() {
    }
    
    func testEvent() {
        
        if let event = Event("First", startTime:"*", endTime:"*") {
            guard let json = event.toJSON() else {
                assert(true, "string is nil")
                return
            }
            let stringEvent = Event(json: json)
            guard let string = stringEvent?.toString() else {
                assert(true, "string is nil")
                return
            }
            print(string)
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
