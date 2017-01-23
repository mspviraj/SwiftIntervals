//
//  NextTimeTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/23/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class NextTimeTests: XCTestCase {
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
    
    func test5() {
        let date = DateEnum.dateFrom(string: birthday)!
        let nextTime = NextTime.with(date: date, interval: 5)
        let calendar = Calendar.current
        let baseHour = calendar.component(.hour, from: date)
        let hour = calendar.component(.hour, from: nextTime)
        XCTAssertEqual(hour, baseHour+1)
        let minute = calendar.component(.minute, from: nextTime)
        XCTAssertEqual(minute, 0)
        print("next time:\(nextTime)")
    }
    
    func test15at10() {
        let date = DateEnum.dateFrom(string: "1960-12-19T20:10:00Z")!
        let nextTime = NextTime.with(date: date, interval: 15)
        let calendar = Calendar.current
        let baseHour = calendar.component(.hour, from: date)
        let hour = calendar.component(.hour, from: nextTime)
        XCTAssertEqual(hour, baseHour)
        let minute = calendar.component(.minute, from: nextTime)
        XCTAssertEqual(minute, 15)
        print("next time:\(nextTime)")

    }
    
    func test15at26() {
        let date = DateEnum.dateFrom(string: "1960-12-19T20:26:00Z")!
        let nextTime = NextTime.with(date: date, interval: 15)
        let calendar = Calendar.current
        let baseHour = calendar.component(.hour, from: date)
        let hour = calendar.component(.hour, from: nextTime)
        XCTAssertEqual(hour, baseHour)
        let minute = calendar.component(.minute, from: nextTime)
        XCTAssertEqual(minute, 30)
        print("next time:\(nextTime)")
        
    }
    
    func test15at33() {
        let date = DateEnum.dateFrom(string: "1960-12-19T20:33:00Z")!
        let nextTime = NextTime.with(date: date, interval: 15)
        let calendar = Calendar.current
        let baseHour = calendar.component(.hour, from: date)
        let hour = calendar.component(.hour, from: nextTime)
        XCTAssertEqual(hour, baseHour)
        let minute = calendar.component(.minute, from: nextTime)
        XCTAssertEqual(minute, 45)
        print("next time:\(nextTime)")
        
    }
 
}
