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
    
    fileprivate let key = "EventsListTests"
    
    override func setUp() {
        super.setUp()
        CloudManager.delete(withKey: key)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        CloudManager.delete(withKey: key)
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
    
    func testGetEvents() {
        var eventList = EventList.getEvents(withKey: key)
        XCTAssertNotNil(eventList)
        XCTAssertTrue(eventList?.list.count == 1)
        let event = Event()
        eventList?.list.append(event.toString()!)
        let save : Bool = (eventList?.saveEvents(withKey: key))!
        XCTAssertTrue(save)
        let result = EventList.getEvents(withKey: key)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.list.count, 2)
    }
}
