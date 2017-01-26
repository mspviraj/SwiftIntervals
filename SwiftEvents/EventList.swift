//
//  EventList.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/24/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import Gloss

struct EventList : JSONSerializable, Glossy {
    var list : [String] = [String]()
    
    private struct Constants {
        static let key = "events"
        static let rootName = "list"
    }
    
    init() {
        self.list.append(Event().toString()!)
    }
    
    //For Glossy protocol
    internal init?(json: JSON) {
        self.list = (Constants.rootName <~~ json)!
    }
    
    //For Glossy protocol
    internal func toJSON() -> JSON? {
        return jsonify([
            Constants.rootName ~~> self.list
            ])
    }
    
    init?(_ data : Data) {
        do {
            var convertedJSON : JSON? = [:]
            try convertedJSON = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON
            guard let json = convertedJSON else {
                return nil
            }
            guard let builtList = EventList(json: json) else {
                return nil
            }
            self.list = builtList.list
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getEvents(withKey key: String = Constants.key) -> EventList? {
        
        guard let content : String = CloudManager.get(withKey: key) else {
            return EventList()
        }
        guard let data = content.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        guard let events = EventList(data) else {
            return nil
        }
        return events
    }
    
    func saveEvents(withKey key: String = Constants.key) -> Bool {
        guard let eventListAsString = self.toString() else {
            return false
        }
        CloudManager.save(json: eventListAsString, withKey: key)
        return true
    }
    
    
    func asData() -> Data? {
        return self.toString()?.data(using: .utf8)
    }
    
    func info(at: Int) -> EventInfo? {
        guard at >= 0 && at < list.count else {
            return nil
        }
        guard let event = Event(list[at]) else {
            return nil
        }
        return event.information
    }
}
