//
//  CloudDropbox.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/13/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation
import SwiftyDropbox
@testable import SwiftEvents

class CloudDropbox {
    
    private let dropboxClient : DropboxClient
    let notificationCenter : NotificationCenter
    
    init?(dropboxClient : DropboxClient?, notificationCenter: NotificationCenter) {
        if dropboxClient == nil {
            return nil
        }
        self.dropboxClient = dropboxClient!
        self.notificationCenter = notificationCenter
    }
    
    func saveOrCreateOnCloud(data: Data, filePath path: String, notificationName: String) {
        _ = self.dropboxClient.files.upload(path: path, mode: .overwrite, input: data)
            .response { (response, error) in
                var userInfo : Dictionary<UserInfoKeys, Any>? = nil
                if let response = response {
                    print("Save Response:\(response)")
                    userInfo = [.cloudCode : CloudCodes.ok, .cloudType : CloudTypes.fromDropbox, .servicePayload : response]
                } else if let error = error {
                    print("Save Error:\(error)")
                    userInfo = [.cloudCode : CloudCodes.error, .cloudType : CloudTypes.fromDropbox, .servicePayload : error]
                }
                self.notificationCenter.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: userInfo)
            }
            .progress { progressData in
                print("Progress Info:\(progressData)")
                let userInfo: [UserInfoKeys : Any] = [.cloudCode : CloudCodes.progress, .cloudType : CloudTypes.fromDropbox, .servicePayload : progressData]
                self.notificationCenter.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: userInfo)
        }
    }
    
    func getDataFromCloud(filePath path: String, notificationName: String) {
        self.dropboxClient.files.download(path: path)
            .response { response, error in
                if let response = response {
                    let responseMetadata : Files.FileMetadata = response.0
                    print(responseMetadata)
                    let fileContents : Data = response.1
                    let userInfo : [UserInfoKeys: Any] = [.cloudCode: CloudCodes.ok, .cloudType: CloudTypes.fromDropbox, .servicePayload: response, .cloudData: fileContents]
                    self.notificationCenter.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: userInfo)
                } else if let error : CallError = error {
                    var userInfo: [UserInfoKeys: Any] = [.cloudType: CloudTypes.fromDropbox, .servicePayload: error]
                    switch error {
                    case .routeError(let boxed, _) :
                        switch boxed.unboxed {
                        case .path(let lookupError) :
                            print("Couldn't find it:\(lookupError.description)")
                            switch lookupError {
                            case .notFound :
                                userInfo[.cloudCode] = CloudCodes.notFound
                            case .notFile:
                                userInfo[.cloudCode] = CloudCodes.notFile
                            default:
                                print("Can't. Why \(lookupError.description)")
                            }
                        case .other:
                            print("Other")
                        }
                    default:
                        userInfo[.cloudCode] = CloudCodes.other
                    }
                    print(error)
                    self.notificationCenter.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: userInfo)
                }
            }
            .progress { progressData in
                let userInfo: [UserInfoKeys : Any] = [.cloudCode : CloudCodes.progress, .cloudType : CloudTypes.fromDropbox, .servicePayload : progressData]
                self.notificationCenter.post(name: NSNotification.Name(rawValue: notificationName), object: nil, userInfo: userInfo)
        }
    }
}
