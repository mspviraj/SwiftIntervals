//
//  EventTableViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/22/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    var events = EventList()
    
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
        return events.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        
        // Configure the cell...
        guard let eventInformation = events.info(at: indexPath.row) else {
            cell.name.text = "Invalid event"
            return cell
        }
        cell.name.text = eventInformation.name
        cell.interval.text = eventInformation.interval
        cell.caption.text = eventInformation.caption
        return cell
    }
    
    @IBAction func updateInterval(segue: UIStoryboardSegue) {
        if let selectedValue = (segue.source as? IntervalViewController)?.selectedInterval {
            if updateInterval(to: selectedValue) {
                startRefreshTimer()
            }
        }
    }
    
    private func updateInterval(to: Int) -> Bool {
        var preferences = Preferences.get()
        if preferences.refreshInSeconds! != to {
            preferences.refreshInSeconds = to
            preferences.save()
            return true
        }
        return false
    }
    var timer : Timer? = nil
    
    public func startRefreshTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        guard let refreshInterval : Int = Preferences.get().refreshInSeconds else {
            assertionFailure("Could not find refresh")
            return
        }
        let timerDate = NextTime.with(date: Date(), interval: refreshInterval)
        print("Timer will run at:\(timerDate) at interval:\(refreshInterval)")
        timer = Timer.init(fire: timerDate, interval: Double(refreshInterval), repeats: true){ (timer) in
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
