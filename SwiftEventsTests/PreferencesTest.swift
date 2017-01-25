//
//  PreferencesTest.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/24/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
@testable import SwiftEvents

class PreferencesTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPrefs() {
        let pref = Preferences()
        XCTAssertNotNil(pref.refreshInSeconds)
        guard let time = pref.refreshInSeconds else {
            XCTFail()
            return
        }
        XCTAssertEqual(time, 60)
        
        guard let json = pref.toString() else {
            XCTFail()
            return
        }
        
        guard let rebuild = Preferences(jsonString: json) else {
            XCTFail()
            return
        }
        XCTAssertEqual(rebuild.refreshInSeconds!, pref.refreshInSeconds!)
        XCTAssertEqual(rebuild.lastCloudUpdate!, pref.lastCloudUpdate!)
        
    }
    
    func testGetSave() {
        let key = "TestPreferences"
        var p : Preferences = Preferences.get(withKey: key)
        XCTAssertEqual(p.refreshInSeconds, 60)
        
        p.refreshInSeconds = 30
        
        p.save(withKey: key)
        
        let q : Preferences = Preferences.get(withKey: key)
        XCTAssertEqual(q.refreshInSeconds, 30)
        XCTAssertEqual(p.lastCloudUpdate, q.lastCloudUpdate)
        CloudManager.delete(withKey: key)
    }
}
