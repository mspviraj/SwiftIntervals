//
//  EventTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/9/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
import Gloss

class EventTests: XCTestCase {
    
    fileprivate let birthday : String = "1960-12-19T20:56:00Z"
    fileprivate let future   : String = "2017-01-01T20:56:00Z"
    fileprivate let nextXMas : String = "2017-12-25T00:00:00Z"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventInit() {
    }
    
    func testInitEvent() {
        let now = Date()
        let event = Event()
        guard let nowString = DateEnum.stringFrom(date: now) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(nowString, event.start)
    }
    
    func testToString() {
        let event = Event()
        let asString = event.toJSON()
        XCTAssertNotNil(asString)
    }
    
    func testInitJSON() {
        let now = Date()
        let event = Event()
        guard let nowString = DateEnum.stringFrom(date: now) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(nowString, event.start)
        
        let json : JSON = event.toJSON()!
        print("json:\(json)")
        XCTAssertNotNil(json)
        guard let event2 = Event(json: json) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(event.name, event2.name)
        XCTAssertEqual(event.start, event2.start)
        XCTAssertEqual(event.finish, event2.finish)
    }
    
    func testInitWithStart() {
        
        guard let event = Event(name: "My Event", startTime: birthday) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(event.start, birthday)
        XCTAssertEqual(event.finish, DateEnum.dateWildCard)
    }
    
    func testCaptioning() {
        guard let event = Event(name: "My Event", startTime: birthday) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(event.start, birthday)
        XCTAssertEqual(event.finish, DateEnum.dateWildCard)
        let caption = event.publishCaption()
        XCTAssertEqual(caption, "Since " + Date.fromUTC(string: birthday)!)
    }
    
    func testFutureCaption() {
        guard let event = Event(name: "Next Christmas", startTime: nextXMas) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(event.start, nextXMas)
        XCTAssertEqual(event.finish, DateEnum.dateWildCard)
        let caption = event.publishCaption()
        XCTAssertEqual(caption, "Until " + Date.fromUTC(string: nextXMas)!)
        
    }
    
    func testDateExtension() {
        if let myBirthday = Date.fromUTC(string: birthday) {
            XCTAssertEqual(myBirthday, "19-Dec-1960 3:56:00 PM")
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testPublishInterval() {
        guard let event = Event(name: "Next Christmas", startTime: future, endTime: nextXMas) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(event.start, future)
        XCTAssertEqual(event.finish, nextXMas)
        let caption = event.publishCaption()
        let results = "Between \(Date.fromUTC(string: future)!) and \(Date.fromUTC(string: nextXMas)!)"
        XCTAssertEqual(results, caption)
        
        let interval = event.publishInterval()
        XCTAssertNotEqual(interval, "Hello")
        
    }
    
    func testEventToJSONandBack() {
        let event = Event()
        let json = event.toString()
        XCTAssertNotNil(json)
        let data = json?.data(using: .utf8)
        if let parsed = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
            let e = Event(json: parsed)
            print("e=\(e)")
            XCTAssertNotNil(e)
        } else {
            XCTAssertNotNil(nil)
        }
        
    }
}
