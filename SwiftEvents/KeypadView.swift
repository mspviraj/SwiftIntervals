//
//  KeypadView.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/27/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit
@IBDesignable

class KeypadView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var labelView: UILabel!      //tag:16
    @IBOutlet weak var oneButton: UIButton! {    //tag:1
        didSet {
            setCaption(onButton: oneButton)
        }
    }
    @IBOutlet weak var twoButton: UIButton! {    //tag:2
        didSet {
            setCaption(onButton: twoButton)
        }
    }
    
    @IBOutlet weak var threeButton: UIButton! {  //tag:3
        didSet {
            setCaption(onButton: threeButton)
        }
    }
    @IBOutlet weak var fourButton: UIButton! {  //tag:4
        didSet {
            setCaption(onButton: fourButton)
        }
    }
    @IBOutlet weak var fiveButton: UIButton! {   //tag:5
        didSet {
            setCaption(onButton: fiveButton)
        }
    }
    @IBOutlet weak var sixButton: UIButton! {    //tag:6
        didSet {
            setCaption(onButton: sixButton)
        }
    }
    @IBOutlet weak var sevenButton: UIButton! {   //tag:7
        didSet {
            setCaption(onButton: sevenButton)
        }
    }
    @IBOutlet weak var eightButton: UIButton! {  //tag:8
        didSet {
            setCaption(onButton: eightButton)
        }
    }
    @IBOutlet weak var nineButton: UIButton! {    //tag:9
        didSet {
            setCaption(onButton: nineButton)
        }
    }
    @IBOutlet weak var backButton: UIButton! {   //tag:10
        didSet {
            setCaption(onButton: backButton)
        }
    }
    @IBOutlet weak var zeroButton: UIButton! {   //tag:11
        didSet {
            setCaption(onButton: zeroButton)
        }
    }
    @IBOutlet weak var clearButton: UIButton! {  //tag:12
        didSet {
            setCaption(onButton: clearButton)
        }
    }
    @IBOutlet weak var submitButton: UIButton! { //tag:13
        didSet {
            setCaption(onButton: submitButton)
        }
    }
    
    @IBOutlet weak var amPmStack: UIStackView!  //tag:17
    
    @IBOutlet weak var amButton: UIButton!     { //tag:14
        didSet {
            setCaption(onButton: amButton)
        }
    }
    @IBOutlet weak var pmButton: UIButton! {     //tag:15
        didSet {
            setCaption(onButton: pmButton)
        }
    }
    
    private func setCaption(onButton button: UIButton) {
        if let caption = captions[button.tag] {
            button.setTitle(caption, for: .normal)
        }
        checkIfDisable(button: button)
    }
    
    private var fromKeypad : FromKeyPad? = nil
    
    var captions : [Int:String] = [Int:String]() { didSet {
        for (tag,caption) in captions {
            if tag > 0, let view = self.viewWithTag(tag) {
                if let button = view as? UIButton {
                    button.setTitle(caption, for: .normal)
                }
            }
        }
        }
    }
    
    
    var disabled : [Int] = [Int]() { didSet {
        for tag in disabled {
            if tag > 0, let view = self.viewWithTag(tag) {
                if let button = view as? UIButton {
                    button.isEnabled = false
                }
            }
 
        }
        }
    }
    
    var hideAmPm : Bool = false { didSet {
        amPmStack?.isHidden = hideAmPm
        }
    }
    
    private func checkIfDisable(button: UIButton) {
        guard button.tag != 0 else {
            assertionFailure("button \(button) has 0 tag")
            return
        }
        for tag in disabled {
            if tag == button.tag {
                button.isEnabled = false
            }
        }
        button.isEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    func xibSetUp() {
        view = loadNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func set(notification name: Notification.Name, forCenter center: MyNotificationCenter) {
        self.fromKeypad = FromKeyPad(notificationCenter: center, notificationName: name)
    }
    
    @IBAction func onKeypressed(_ sender: UIButton) {
        let tag = sender.tag
        guard tag != 0 else {
            assertionFailure("\(sender.titleLabel)\(sender) has 0 tag")
            return
        }
        if fromKeypad != nil {
            fromKeypad?.broadcast(uiTag: tag, uiText: (sender.titleLabel?.text!)!, labelText: labelView!.text!)
        }
    }
    
}
