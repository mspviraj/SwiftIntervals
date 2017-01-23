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
        let cloudManager = CloudManager()
        cloudManager.deleteEvents(withKey: managerKey)
    }
    
    override func tearDown() {
        let cloudManager = CloudManager()
        cloudManager.deleteEvents(withKey: managerKey)
        super.tearDown()
    }
    
    func testGetEvents() {
        let cloudManager = CloudManager()
        let events = cloudManager.getEvents(withKey: managerKey)
        XCTAssertNotNil(events)
        let saved = cloudManager.saveEvents(events!, withKey: managerKey)
        XCTAssertTrue(saved)
        XCTAssertNotNil(events)
        let recalled = cloudManager.getEvents(withKey: managerKey)
        XCTAssertNotNil(recalled)
        print("event:\(events?.toString())")
        print("recall:\(recalled?.toString())")
        XCTAssertEqual(events?.toString(), recalled?.toString())
    }
}
