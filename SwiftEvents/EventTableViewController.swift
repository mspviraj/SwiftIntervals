//
//  EventTableViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/22/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    private struct Constants {
        static let popoverSegue = "New Event"
    }
    
    @IBOutlet weak var intervalButton: UIBarButtonItem!
    
    var events = EventList.getEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let cloudManager = CloudManager()
        //        guard let loadEvents = cloudManager.getEvents(withKey: "Events") else {
        //            assertionFailure("Could not load events")
        //            return;
        //        }
        //        events = loadEvents
        
        
        tableView.rowHeight = 78
        tableView.estimatedRowHeight = 78
        //tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRefreshTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View disappearing")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        
        // Configure the cell...
        guard let event = events?.event(at: indexPath.row) else {
            cell.name.text = "Invalid event"
            return cell
        }
        cell.name.text = event.name
        cell.interval.text = event.publishInterval()
        cell.caption.text = event.publishCaption()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if segue.identifier == Constants.popoverSegue {
            if let newevent = destination as? AddEventTableViewController {
                if let popoverPresentationController = newevent.popoverPresentationController {
                    popoverPresentationController.delegate = self //Makes func presentationController get called
                }
            }
        }
    }
    
    //Control the presentation style on iPhone vs iPad for popovers
    func presentationController(_ controller: UIPresentationController,
                                viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        if style == .fullScreen {
            let naviationController = UINavigationController(rootViewController: controller.presentedViewController)
            return naviationController
        } else {
            return nil
        }
    }
    
    @IBAction func updateInterval(segue: UIStoryboardSegue) {
        if let refreshRate : RefreshRates = (segue.source as? IntervalViewController)?.refreshRate {
            if updateInterval(to: refreshRate) {
                startRefreshTimer()
            }
        }
    }
    
    
    private func updateInterval(to: RefreshRates) -> Bool {
        var preferences = Preferences.get()
        if let currentRate : RefreshRates = RefreshRates.from(seconds: preferences.refreshInSeconds!) {
            if currentRate != to {
                preferences.refreshInSeconds = to.asSeconds()
                preferences.save()
                return true
            }
        }
        return false
    }
    
    private func updateCaptionTo(refreshRate : RefreshRates) {
        switch refreshRate {
        case .second:
            self.intervalButton?.title = "1 Sec"
        case .minute:
            self.intervalButton?.title = "1 Min"
        case .fiveMinutes:
            self.intervalButton?.title = "5 Mins"
        case .fifteenMinutes:
            self.intervalButton?.title = "15 Mins"
        case .thirtyMinutes:
            self.intervalButton?.title = "30 Mins"
        case .hour:
            self.intervalButton?.title = "1 hr"
        }
    }
    var timer : Timer? = nil
    
    public func startRefreshTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        guard let refreshSeconds : Int = Preferences.get().refreshInSeconds else {
            assertionFailure("Could not find refresh")
            return
        }
        guard let refreshRate : RefreshRates = RefreshRates.from(seconds: refreshSeconds) else {
            assertionFailure("Invalid refresh rate:\(refreshSeconds)")
            return
        }
        updateCaptionTo(refreshRate: refreshRate)
        let timerDate = NextTime.with(date: Date(), refreshRate: refreshRate)
        print("Timer will run at:\(timerDate) at interval:\(refreshSeconds)")
        timer = Timer.init(fire: timerDate, interval: Double(refreshSeconds), repeats: true){ (timer) in
            print("date:\(Date())")
            self.tableView.reloadData()
        }
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
