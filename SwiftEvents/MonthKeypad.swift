//
//  MonthKeypad.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/27/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit
@IBDesignable

class MonthKeypad: UIView {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet var view: UIView!
    
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
    
    @IBAction func monthButtons(_ sender: UIButton) {
    }
    
    @IBAction func selectDayButton(_ sender: UIButton) {
    }
}
