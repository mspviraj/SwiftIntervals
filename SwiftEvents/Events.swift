//
//  Events.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/8/17.
//  Copyright © 2017 LTMM. All rights reserved.
//
// Manages a collection/array of Event classes
//
import Foundation
import Gloss

struct Events2 : Glossy {
    var events : [Event2] = [Event2]()
    init() {
        events.append(Event2())
        events.append(Event2())
    }
    init?(json: JSON) {
        self.events = ("events" <~~ json)!
    }
    func toJSON() -> JSON? {
        return jsonify([
            "events" ~~> self.events
            ])
    }
    
    func toString() -> String {
        func buildList(_ items : [Event2], index: Int) -> String {
            if index < items.count - 1 {
                let asJSONstring = items[index].toString()
                let list = buildList(items, index: index + 1)
                return asJSONstring + "," + list
            }
            return items[index].toString()
        }
        
        let listOfEvents = buildList(events, index: 0)
        return "\"events\":[\(listOfEvents)]"
        
    }
    
}

struct Events : Decodable, JSONSerializable, Glossy {
    var events : [Event] = [Event]()
    
    init() {
        events.append(Event())
    }
    
    init?(json: JSON) {
        let m = json.description
        print(m)
        
        guard let z : Event = ("events" <~~ json) else {
            return nil
        }
        print("found:\(z)")
        events = ("events" <~~ json)!
    }
    
    init?(event : Event) {
        events.append(event)
    }
    
    init?(_ data : Data) {
        do {
            var convertedJSON : JSON? = [:]
            try convertedJSON = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON
            guard let json = convertedJSON else {
                return nil
            }
            let events = Events(json: json)
            self.events = (events?.events)!
        } catch {
            print(error)
            return nil
        }
    }
    
    func getEvents() -> [Event] {
        return self.events
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "events" ~~> self.events
            ])
    }
    
    
    //    func toString() -> String? {
    //        func buildList(_ items : [Event], index: Int) -> String? {
    //            if index < items.count - 1 {
    //                guard let asJSONstring = items[index].toString() else {
    //                    return nil
    //                }
    //                guard let list = buildList(items, index: index + 1) else {
    //                    return nil
    //                }
    //                return asJSONstring + "," + list
    //            }
    //            return items[index].toString()
    //        }
    //
    //        guard let listOfEvents = buildList(events, index: 0) else {
    //            return nil
    //        }
    //
    //        return "{\"events\":[\n" + listOfEvents + "\n]}"
    //
    //    }
}
