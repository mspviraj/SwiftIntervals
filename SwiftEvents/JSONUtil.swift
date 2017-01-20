//
//  JSONUtil.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/9/17.
//  Copyright © 2017 LTMM. All rights reserved.
//
// Convert Swift structs to JSON


import Foundation

//: ### Defining the protocols
protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {
    
}


//: ### Implementing the functionality through protocol extensions
extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        
        //discover and interate over the list of properties of the struct
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            switch value {
                
            case let value as Dictionary<String, AnyObject>:
                representation[label] = value as AnyObject?
                
            case let value as Array<AnyObject>:
                representation[label] = value as AnyObject?
                
            case let value as AnyObject:
                representation[label] = value
                
            case let value as Dictionary<String, JSONSerializable>:
                representation[label] = value.map({$0.value.JSONRepresentation}) as AnyObject?
                
            case let value as Array<JSONSerializable>:
                representation[label] = value.map({$0.JSONRepresentation}) as AnyObject?
                
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}

extension JSONSerializable {
    func toString() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

