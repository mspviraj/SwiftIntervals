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
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(nowString, event.start)
    }
    
    func testInitJSON() {
        let now = Date()
        let event = Event()
        guard let nowString = DateEnum.stringFrom(date: now) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(nowString, event.start)
        
        let json : JSON = event.toJSON()!
        print("json:\(json)")
        XCTAssertNotNil(json)
        guard let event2 = Event(json: json) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(event.displayInterval, event2.displayInterval)
        XCTAssertEqual(event.name, event2.name)
        XCTAssertEqual(event.start, event2.start)
        XCTAssertEqual(event.finish, event2.finish)
    }
    
    func testInitWithStart() {

        guard let event = Event(name: "My Event", startTime: birthday) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(event.start, birthday)
        XCTAssertEqual(event.finish, DateEnum.dateWildCard)
    }
    
}
