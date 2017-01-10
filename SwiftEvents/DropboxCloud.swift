//
//  DropboxCloud.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/8/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import SwiftyDropbox

enum CloudErrors : Error {
    case ok
    case invalidString
    case saveError
    case getError
    case notFound
    case notFile
    case badFile
}

class DropboxCloud {
    
    let client = DropboxClientsManager.authorizedClient
    
    var filePath : String
    
    init(filePath : String) {
        self.filePath = filePath
    }
    
    
    func saveString(_ jsonString: String, completion: @escaping (CloudErrors)-> Void) {
        guard let fileData = jsonString.data(using: .utf8, allowLossyConversion: false) else {
            completion(CloudErrors.invalidString)
            return
        }
        
        
        _ = client?.files.upload(path: self.filePath, mode: .overwrite, input: fileData)
            .response { response, error in
                if response != nil {
                    completion(CloudErrors.ok)
                } else if error != nil {
                    completion(CloudErrors.saveError)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        
    }
    
    
    func getString(completion: @escaping (String?, CloudErrors) -> Void) {
        client?.files.download(path: self.filePath)
            .response { response, error in
                if let response = response {
                    let responseMetadata = response.0
                    print(responseMetadata)
                    let fileContents = response.1
                    if let contentsAsString = String(data: fileContents, encoding: .utf8) {
                        completion(contentsAsString, CloudErrors.ok)
                    } else {
                        completion(nil, CloudErrors.invalidString)
                    }
                } else if let error = error {
                    let j = error as CallError
                    switch j {
                    case .routeError(let boxed, _) :
                        switch boxed.unboxed {
                        case .path(let lookupError) :
                            print("Couldn't find it:\(lookupError.description)")
                            switch lookupError {
                            case .notFound :
                                completion(nil, CloudErrors.notFound)
                                return
                            case .notFile:
                                completion(nil, CloudErrors.notFile)
                                return
                            default:
                                print("Can't. Why \(lookupError.description)")
                            }
                        case .other:
                            print("Other")
                        }
                    default:
                        print("Default")
                    }
                    print(error)
                    completion(nil, CloudErrors.getError)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        
    }
}
