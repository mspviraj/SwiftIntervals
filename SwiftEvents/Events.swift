//
//  Events.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/8/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

class Events
{
    enum EventKeys {
        case root
        case event
        case startTime, endTime
    }
    
    let keyEvent = "keyEvent"
    let keyStart = "keyStart"
    let keyEnd = "keyEnd"
    let keyRoot = "keyRoot"
    
    var eventDictionary = [String:Array<String>]()
    
    init() {
        if let json = JSONEvent("Started Using this app", startTime: DateEnum.stringFromDate(Date()), endTime: DateEnum.dateWildCard) {
            eventDictionary[keyRoot] = [json]
        }
    }
    
    func asJSON() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: eventDictionary, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func JSONEvent(_ eventName : String, startTime: String, endTime: String) -> String? {
        let dict : [String:String] = [keyEvent : eventName, keyStart : startTime, keyEnd : endTime]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                print(dictFromJSON)
            }
            let returnString = String(data: jsonData, encoding: .utf8)
            print(returnString!)
            return returnString
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func addEvent(_ eventName : String, startTime : String, endTime : String) {
        
    }
}
