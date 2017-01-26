//
//  IntervalViewController.swift
//  
//
//  Created by Steven Smith on 1/25/17.
//
//

import UIKit

class IntervalViewController: UIViewController {

    var selectedInterval = 1
    
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
    
    @IBAction func intervalButtons(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            interval(seconds:1)
        case 2:
            interval(seconds: TimeIntervals.kMinute)
        case 3:
            interval(seconds: TimeIntervals.k15Minutes)
        case 4:
            interval(seconds: TimeIntervals.k30Minutes)
        case 5:
            interval(seconds: TimeIntervals.k60Minutes)
        default:
            assertionFailure("Invalid time interval")
        }
    }

    private struct Constants {
        static let updateIntervalSegue = "updateIntevalWithSegue"
    }
    private func interval(seconds: Int) {
        self.selectedInterval = seconds

        self.performSegue(withIdentifier: Constants.updateIntervalSegue, sender: self)
        
    }
}
