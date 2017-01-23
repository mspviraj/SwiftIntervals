//
//  EventsTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/23/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
@testable import SwiftEvents

class EventsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventsToString() {
        let events = Events()
        let asString = events.toString()
        XCTAssertNotNil(asString)
    }
}
