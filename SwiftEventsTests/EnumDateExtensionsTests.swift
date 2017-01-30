//
//  EnumDateExtensionsTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/29/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
@testable import SwiftEvents

class EnumDateExtensionsTests: XCTestCase {
    
    private var theDate : Date {
        let gregorian = Calendar(identifier: .gregorian)
        var dateCompents = DateComponents()
        dateCompents.year = 1960
        dateCompents.month = 12
        dateCompents.day = 19
        dateCompents.hour = 15
        dateCompents.minute = 56
        dateCompents.timeZone = TimeZone(abbreviation: "EDT")
        return gregorian.date(from: dateCompents)!
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFromUTC() {
        let date = theDate
        XCTAssertNotNil(date)
        let string = date.utcString
        XCTAssertEqual(string,"1960-12-19T20:56:00Z")
    }
    
}
