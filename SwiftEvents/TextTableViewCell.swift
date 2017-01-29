//
//  TextTableViewCell.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/28/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var eventText: UITextField! { didSet { self.eventText.delegate = self }}
    
    private var notificationCenter : MyNotificationCenter? = nil
    private var notificationName : Notification.Name? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.eventText.resignFirstResponder()
        return true
    }
}
