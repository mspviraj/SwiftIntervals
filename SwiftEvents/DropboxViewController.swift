//
//  DropboxViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/7/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onConnect(_ sender: UIButton) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler:  { (success) in
                                                            print("Dropbox : \(success)")
                                                        })
                                                        //UIApplication.shared.openURL(url)
        })
    }

    @IBAction func onPush(_ sender: UIButton) {
        
        let client = DropboxClientsManager.authorizedClient
        
        let fileData = "testing data example".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        let request = client?.files.upload(path: "/v.txt", input: fileData)
            .response { response, error in
                if let response = response {
                    print(response)
                } else if let error = error {
                    let j = error as CallError
                    print(j)
                    
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        let someConditionIsSatisfied = false
        // in case you want to cancel the request
        if someConditionIsSatisfied {
            request?.cancel()
        }
    }
    
    @IBAction func onPull(_ sender: UIButton) {
        let client = DropboxClientsManager.authorizedClient!
        client.files.download(path: "/x.txt")
            .response { response, error in
                if let response = response {
                    let responseMetadata = response.0
                    print(responseMetadata)
                    let fileContents = response.1
                    print(fileContents)
                } else if let error = error {
                    let j = error as CallError
                    switch j {
                    case .routeError(let boxed, _) :
                        switch boxed.unboxed {
                        case .path(let lookupError) :
                            print("Couldn't find it:\(lookupError.description)")
                            switch lookupError {
                            case .notFound :
                                print("not found")
                            case .notFile:
                                print("not a file")
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
                }
            }
            .progress { progressData in
                print(progressData)
        }
        
    }
    
}

