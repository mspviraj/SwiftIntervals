//
//  FromKeyPad.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/27/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

struct FromKeyPad {
    static let viewTag = "viewTag"
    static let viewCaption = "viewCaption"
    static let lableContent = "labelContent"
    private let notificationCenter : MyNotificationCenter
    private let notificationName : Notification.Name
    
    init(notificationCenter: MyNotificationCenter, notificationName: Notification.Name) {
        self.notificationCenter = notificationCenter
        self.notificationName = notificationName
    }
    
    mutating func broadcast(uiTag tag: Int, uiText text: String, labelText: String) {
        var payload : [String:Any] = [String:Any]()
        payload[FromKeyPad.viewTag] = tag
        payload[FromKeyPad.viewCaption] = text
        payload[FromKeyPad.lableContent] = labelText
        self.notificationCenter.post(name: self.notificationName, object: self, userInfo: payload)
    }
}

