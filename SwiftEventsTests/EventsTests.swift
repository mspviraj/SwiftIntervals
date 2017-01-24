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
        let asString = events.toJSON()
        XCTAssertNotNil(asString)
    }
    
    func testEventsAsString() {
        let events = Events2()
        let json = events.toString()
        XCTAssertNotNil(json)
        print("\(json)")
        let data = json.data(using: .utf8)
        if let parsed = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
            let e = Events2(json: parsed)
            print("e:\(e)")
        }
    }
}
