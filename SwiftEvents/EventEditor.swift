//
//  EventEditor.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/31/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

class EventEditor {
    private let event : EventContainer
    private var start : DateTimeObject?
    private var finish : DateTimeObject? = nil
    
    init(forEvent: EventContainer) {
        event = forEvent
        start = DateTimeObject(dateTime: event.start, timeZone: event.startingTimeZone)
    }
}

