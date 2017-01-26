//
//  IntervalViewController.swift
//  
//
//  Created by Steven Smith on 1/25/17.
//
//

import UIKit

class IntervalViewController: UIViewController {

    var refreshRate = RefreshRates.minute
    
    @IBOutlet weak var oneSecondInterval: UIButton!
    
    @IBOutlet weak var oneMinuteInterval: UIButton!
    
    @IBOutlet weak var fifteenMinuteInterval: UIButton!
    
    @IBOutlet weak var thirtyMinuteInterval: UIButton!
    
    @IBOutlet weak var oneHourInterval: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onInterval(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            refresh(rate: .second)
        case 2:
            refresh(rate: .minute)
        case 3:
            refresh(rate: .fiveMinutes)
        case 4:
            refresh(rate: .fifteenMinutes)
        case 5:
            refresh(rate: .thirtyMinutes)
        case 6:
            refresh(rate: .hour)
        default:
            refresh(rate: .minute)
        }
    }
    
    private struct Constants {
        static let updateIntervalSegue = "updateIntevalWithSegue"
    }
    private func refresh(rate: RefreshRates) {
        self.refreshRate = rate
        self.performSegue(withIdentifier: Constants.updateIntervalSegue, sender: self)
        
    }
}
