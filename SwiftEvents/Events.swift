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
    
    func writeStatus(error: CloudErrors)->Void {
        print("\(error)")
    }
    
    
    func saveEventsToCloud(path: String, target: Events, completion: @escaping (CloudErrors)->Void = {_ in}){
        let block = DispatchWorkItem {
            guard let jsonString = target.toString() else {
                return
            }
            
            let cloud = DropboxCloud(filePath: path)
            cloud.saveString(jsonString, completion: completion)
        }
        
        let queue = DispatchQueue(label: "cloudWrite",
                                  qos: .background,
                                  target: nil)
        
        queue.sync(execute: block)
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
        let dropbox = DropboxCloud(filePath: path)
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
    
    mutating func add(event: Event,
                      saveToCloud: @escaping(String, Events, @escaping (CloudErrors)->Void)->Void = {_,_,_ in},
                      path:String? = nil,
                      completion:@escaping (CloudErrors)->Void = {_ in }) {
        events.append(event)
        if let filePath = path {
            saveToCloud(filePath, self, completion)
        }
    }
    
    mutating func removeEvent(atIndex index: Int,
                              saveToCloud: @escaping(String, Events, @escaping (CloudErrors)->Void)->Void = {_,_,_ in},
                              path:String? = nil,
                              completion:@escaping (CloudErrors)->Void = {_ in }) {
        guard index >= 0 && index < events.count else {
            completion(.invalidEvent)
            return
        }
        
        events.remove(at: index)
        if events.count == 0 {
            events.append(Event())
        }
        if let filePath = path {
            saveToCloud(filePath, self, completion)
        }
    }
    
    mutating func updateEvent(atIndex index: Int,
                              withNewEvent event: Event,
                              saveToCloud: @escaping(String, Events, @escaping (CloudErrors)->Void)->Void = {_,_,_ in},
                              path:String? = nil,
                              completion:@escaping (CloudErrors)->Void = {_ in }) {
        guard index >= 0 && index < events.count else {
            completion(.invalidEvent)
            return
        }
        
        self.events[index] = event
        if let filePath = path {
            saveToCloud(filePath, self, completion)
        }
    }

}
