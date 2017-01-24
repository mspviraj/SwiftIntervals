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
    
    init() {
        self.list.append(Event().toString()!)
    }
    
    //For Glossy protocol
    internal init?(json: JSON) {
        self.list = ("list" <~~ json)!
    }
    
    //For Glossy protocol
    internal func toJSON() -> JSON? {
        return jsonify([
            "list" ~~> self.list
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
