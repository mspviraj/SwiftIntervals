//
//  AddEventTableViewCell.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/26/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit

class AddEventTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var eventTextField: UITextField! { didSet { eventTextField.delegate = self }}
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var eventName : String = "" { didSet { updateUI() }}
    var startDate : String = Date.fromUTC(string: DateEnum.dateWildCard)! { didSet { updateUI() }}
    var finishDate : String = "Show Elapsed Time" { didSet { updateUI() }}
    
    private func updateUI() {
        eventTextField?.text = eventName
        startButton?.setTitle(startDate, for: .normal)
        finishButton?.setTitle(finishDate, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventTextField.resignFirstResponder()
        return true
    }
    
    private var eventObserver : NSObjectProtocol?
    
    private func listenOnTextField() {
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        eventObserver = center.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange,
                                           object: eventTextField,
                                           queue: queue) { notification in
                                            self.eventName = self.eventTextField!.text!
        }
    }
    
    deinit {
        if let observer = eventObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}
