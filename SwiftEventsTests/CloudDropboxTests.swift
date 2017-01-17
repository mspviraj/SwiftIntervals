//
//  CloudDropboxTests.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/16/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import XCTest
import SwiftyDropbox

class CloudDropboxTests: XCTestCase {
    
    var g : XCTestExpectation? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDropboxInit() {
        let notificationCenter = MockNotificationCenter(center: NotificationCenter.default)
        let dropboxClient : DropboxClient? = DropboxClientsManager.authorizedClient
        let cloudDropbox : CloudDropbox? = CloudDropbox(dropboxClient: dropboxClient, notificationCenter: notificationCenter)
        XCTAssertNotNil(cloudDropbox, "CloudDropbox is nil")
    }
    
    func testWriteDropbox() {
        g = expectation(description: "Zerk")
        let input = "Hello World"
        let data = input.data(using: .utf8, allowLossyConversion: false)
        let notificationCenter = MyNotificationCenter(center: NotificationCenter.default)
        notificationCenter.addObserver(self, selector: #selector(CloudDropboxTests.onZerk), name: NSNotification.Name(rawValue: "ZERK"), object: nil)
        let dropboxClient : DropboxClient? = DropboxClientsManager.authorizedClient
        let cloudDropbox : CloudDropbox? = CloudDropbox(dropboxClient: dropboxClient, notificationCenter: notificationCenter)
        XCTAssertNotNil(cloudDropbox, "CloudDropbox is nil")
        cloudDropbox?.saveOrCreateOnCloud(data: data!, filePath: "/zerk.txt", notificationName: "ZERK")
        
        
        self.waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Timed out")
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    @objc private func onZerk(notification : Notification) {
        guard let userInfo : Dictionary = notification.userInfo else {
            XCTAssertNotNil(notification.userInfo, "User info returned nil")
            return
        }
        guard let cloudCode : CloudCodes = userInfo[UserInfoKeys.cloudCode] as! CloudCodes? else {
            XCTAssert(false, "Missing cloud code")
            return
        }
        switch cloudCode {
        case .error :
            print("Error")
        case .ok :
            g!.fulfill()
        case .progress :
            guard let progress : Progress = userInfo[UserInfoKeys.servicePayload] as! Progress? else {
                XCTAssert(false, "Missing progress in user info")
                return
            }
            print("Completed:\(progress.completedUnitCount) of \(progress.totalUnitCount)")
            return
        case .notFile :
            XCTAssert(false, "Returned file not a file")
        case .notFound :
            XCTAssert(false, "Returned not file")
        case .other :
            XCTAssert(false, "Returned .other")
        }
    }
    
}
