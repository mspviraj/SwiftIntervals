//
//  EventListTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/24/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
@testable import SwiftEvents

class EventListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventList() {
        let list = EventList()
        
        guard let string = list.toString() else {
            XCTFail()
            return
        }
        guard let data = string.data(using: .utf8) else {
            XCTFail()
            return
        }
        if let parsed = try? JSONSerialization.jsonObject(with: data) as! [String:Any] {
            let rebuilt = EventList(json: parsed)
            XCTAssertNotNil(rebuilt)
        } else {
            XCTFail()
        }
    }
    
    func testEventListData() {
        let list = EventList()
        guard let data = list.asData() else {
            XCTFail("data is nil")
            return
        }
        XCTAssertNotNil(data)
        let list2 = EventList(data)
        XCTAssertNotNil(data)
        XCTAssertEqual(list2?.list.count, 1)
    }
    
    func testEventListEventAt() {
        let list = EventList()
        guard let event = list.info(at: 0) else {
            XCTFail("Nil info")
            return
        }
        print("\(event)")
    }
    
    func testEventListEventAtBadIndex() {
        let list = EventList()
        let event = list.info(at: 100)
        XCTAssertNil(event)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        let list = EventList()
        self.measure {
            guard let data = list.asData() else {
                XCTFail("data is nil")
                return
            }
            XCTAssertNotNil(data)
            let list2 = EventList(data)
            XCTAssertNotNil(data)
            XCTAssertEqual(list2?.list.count, 1)
        }
    }
    
}
