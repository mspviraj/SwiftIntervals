//
//  DateEnumTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/8/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class DateEnumTests: XCTestCase {
    
    fileprivate let birthday : String = "1960-12-19T20:56:00Z"
    fileprivate let birthday2 : String = "1960-12-19T20:56:00+00:00"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUTC() {
        guard let dateValue = DateEnum.dateFrom(string: birthday) else {
            XCTAssert(false, "Cannot parse dateVakye from:\(birthday)")
            return
        }
        guard let dateString = DateEnum.stringFrom(date: dateValue) else {
            XCTAssert(false, "Cannot get dateValue from date:\(dateValue) ")
            return
        }
        XCTAssertEqual(dateString, birthday, "String:\(dateString) does not match \(birthday)")
        
    }
    
    
}
