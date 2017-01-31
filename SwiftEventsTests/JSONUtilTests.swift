//
//  JSONUtilTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/24/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
@testable import SwiftEvents

class JSONUtilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringToDictionary() {
        let event = Event()
        guard let string = event.toString() else {
            XCTFail("Nil String")
            return
        }
        guard let dict = string.toDictionary() else {
            XCTFail("Nil Dictionary")
            return
        }
        
        let name = dict["name"]
        XCTAssertNotNil(name)
        let nope = dict["jibberish"]
        XCTAssertNil(nope)
        
    }
    
}
