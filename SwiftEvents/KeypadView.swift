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
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var amPmStack: UIStackView!
    @IBOutlet weak var amButton: UIButton!
    @IBOutlet weak var pmButton: UIButton!
    
    
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
}
