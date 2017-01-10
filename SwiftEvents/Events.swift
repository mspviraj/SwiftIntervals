//
//  Events.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/8/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import Gloss

struct Events : JSONSerializable, Glossy {
    var events : [Event] = [Event]()
    
    init?(json: JSON) {
        events = ("events" <~~ json)!
    }
    
    init?(event : Event) {
        events.append(event)
    }
    
    init?(path : String) {
        let dropboxCloud = DropboxCloud(filePath: path)
        dropboxCloud.getString() { String, CloudErrors in
        }
    }
    
    init?(_ string : String) {
         guard let data = string.data(using: .utf8) else {
            return nil
        }
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
    
    mutating func addEvent(event : Event) -> Int {
        events.append(event)
        return events.count
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "events" ~~> self.events
            ])
    }
    
    func toString() -> String? {
        func buildList(_ items : [Event], index: Int) -> String {
            if index < items.count - 1 {
                return items[index].toString()! + "," + buildList(items, index: index + 1)
            }
            return items[index].toString()!
        }
        
        return "{\"events\":[\n" + buildList(events, index: 0) + "\n]}"
        
    }
    
    static func EventSetup(path : String, completion: @escaping (Events?, CloudErrors) -> Void) {
        let dropbox = DropboxCloud(filePath: "/MyEvents.json")
        dropbox.getString() { jsonString, error in
            switch(error) {
            case .ok :
                if let events = Events(jsonString!) {
                    completion(events, .ok)
                } else {
                    completion(nil, .badFile)
                }
            case .notFound:
                if let events = Events(event: Event()) {
                    let asString = events.toString()
                    if let string = asString {
                        dropbox.saveString(string) { (cloudError : CloudErrors) in
                            completion(events, cloudError)
                        }
                    }
                    
                }
            default:
                completion(nil, error)
            }
        }
    }
}
