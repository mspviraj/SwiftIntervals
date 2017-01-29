//
//  AddEventViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/27/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    

    @IBOutlet weak var paletView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadKeypad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func loadKeypad() {
        let keypad = KeypadView()
        keypad.disabled = [1,4]
        keypad.captions = [2:"X", 9:"Y"]
        keypad.hideAmPm = true
        self.paletView.addSubview(keypad)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
