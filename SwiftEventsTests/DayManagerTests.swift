//
//  DayManagerTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/12/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest

class DayManagerTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDayManager() {
        
        let notificationCenter = MockNotificationCenter(center: NotificationCenter.default)
        let dayManager = DayManager(notificationCenter: notificationCenter, maxDay:31)
        XCTAssertNotNil(dayManager, "dayManager is nil")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testDayRanges() {
        
        let notificationCenter = MockNotificationCenter(center: NotificationCenter.default)
        
        for d in 0...3 {
            for e in 0...9 {
                guard let dayManager = DayManager(notificationCenter: notificationCenter, maxDay:31) else {
                    XCTAssertTrue(false, "Could not create day manager")
                    break;
                }
                
                var test : String = ""
                if (d != 0) {
                    test = String(d)
                    dayManager.add(string: test)
                    guard let checkStatus = notificationCenter.userInfo?[CalendarManagerCodes.keyStatus] else {
                        XCTAssert(false, "Could not find in dictionary")
                        break
                    }
                    let status = checkStatus as! CalendarManagerCodes
                    print("first \(test) returns \(status)")
                }
                test += String(e)
                print("testing: \(test)")
                dayManager.add(string: String(e))
                
                guard let checkStatus = notificationCenter.userInfo?[CalendarManagerCodes.keyStatus] else {
                    XCTAssert(false, "Could not find in dictionary")
                    break
                }
                let status = checkStatus as! CalendarManagerCodes
                
                guard let checkBuild = notificationCenter.userInfo?[CalendarManagerCodes.keyBuild] else {
                    XCTAssert(false, "Can not find checkBuild")
                    break;
                }
                let build = checkBuild as! String
                
                guard let checkResult = notificationCenter.userInfo?[CalendarManagerCodes.keyResult] else {
                    XCTAssert(false, "Could not find result")
                    break
                }
                let day = Int(checkResult as! String)!
                
                print("testing:\(test) status:\(status) day=\(day) build:\(build)")
                
                switch day {
                case 0:
                    guard status == .badInput else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 1...3:
                    guard status == .building else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 4...9:
                    guard status == .completed else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 10:
                    guard status == .building else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 11...19:
                    guard status == .completed else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 20:
                    guard status == .building else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 21...29:
                    guard status == .completed else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 30:
                    guard status == .building else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                case 31:
                    guard status == .completed else {
                        XCTAssertTrue(false, "Status is \(status)")
                        break;
                    }
                default:
                    guard status == .badInput else {
                        XCTAssertTrue(false, "invalid date")
                        break;
                    }
                }
                
            }
        }
    }
    
    func testSpecial() {
        let notificationCenter = MockNotificationCenter(center: NotificationCenter.default)
        
        let choice = ["10","20","30"]
        for i in choice {
            guard let dayManager = DayManager(notificationCenter: notificationCenter, maxDay:31) else {
                XCTAssertTrue(false, "Could not create day manager")
                break
            }
            dayManager.add(string: i)
            guard let checkStatus = notificationCenter.userInfo?[CalendarManagerCodes.keyStatus] else {
                XCTAssert(false, "Could not find in dictionary")
                break
            }
            let status = checkStatus as! CalendarManagerCodes
            
            guard let checkBuild = notificationCenter.userInfo?[CalendarManagerCodes.keyBuild] else {
                XCTAssert(false, "Can not find checkBuild")
                break;
            }
            let build = checkBuild as! String
            
            guard let checkResult = notificationCenter.userInfo?[CalendarManagerCodes.keyResult] else {
                XCTAssert(false, "Could not find result")
                break
            }
            let day = checkResult as! String
            
            print("status:\(status) build:\(build) day:\(day)")
            XCTAssertTrue(status == .building, "Status failed:\(status)")
            XCTAssertTrue(build == i, "Build:\(build)")
            XCTAssertTrue(day == i, "Result:\(day)")
        }
    }
    
    func testSpecialWithAdd() {
        let notificationCenter = MockNotificationCenter(center: NotificationCenter.default)
        
        let choice = ["10","20","30"]
        for i in choice {
            guard let dayManager = DayManager(notificationCenter: notificationCenter, maxDay:31) else {
                XCTAssertTrue(false, "Could not create day manager")
                break
            }
            dayManager.add(string: i)
            dayManager.add(string: "1")
            
            guard let checkStatus = notificationCenter.userInfo?[CalendarManagerCodes.keyStatus] else {
                XCTAssert(false, "Could not find in dictionary")
                break
            }
            let status = checkStatus as! CalendarManagerCodes
            
            guard let checkBuild = notificationCenter.userInfo?[CalendarManagerCodes.keyBuild] else {
                XCTAssert(false, "Can not find checkBuild")
                break;
            }
            let build = checkBuild as! String
            
            guard let checkResult = notificationCenter.userInfo?[CalendarManagerCodes.keyResult] else {
                XCTAssert(false, "Could not find result")
                break
            }
            let day = checkResult as! String
            
            print("status:\(status) build:\(build) day:\(day)")
            XCTAssertTrue(status == .completed, "Status failed:\(status)")
            var j : String = "?"
            switch i {
                case "10":
                j = "11"
                case "20":
                j = "21"
                case "30":
                j = "31"
            default:
                XCTAssertTrue(false, "Could not map j:\(j) to i:\(i)")
            }
            
            XCTAssertTrue(build == j, "Build:\(build)")
            XCTAssertTrue(day == j, "Result:\(day)")
        }

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
