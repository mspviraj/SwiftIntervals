//
//  CloudManagerTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/23/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
@testable import SwiftEvents

class CloudManagerTests: XCTestCase {
    
    fileprivate let managerKey : String = "testKey"

    override func setUp() {
        super.setUp()
        CloudManager.delete(withKey: managerKey)
    }
    
    override func tearDown() {
        CloudManager.delete(withKey: managerKey)
        super.tearDown()
    }
    
    func testGetEvents() {
        let events = EventList.getEvents(withKey: managerKey)
        XCTAssertNotNil(events)
        let saved = events?.saveEvents(withKey: managerKey)
        XCTAssertTrue(saved!)
        XCTAssertNotNil(events)
        let recalled = EventList.getEvents(withKey: managerKey)
        XCTAssertNotNil(recalled)
        print("event:\(events?.toJSON())")
        print("recall:\(recalled?.toJSON())")
    }
    
    func testSaveGet() {
        let isNil = CloudManager.get(withKey: managerKey)
        XCTAssertNil(isNil)
        let test = "This is a test string"
        CloudManager.save(json: test, withKey: managerKey)
        let compare = CloudManager.get(withKey: managerKey)
        XCTAssertEqual(test, compare)
    }
}
