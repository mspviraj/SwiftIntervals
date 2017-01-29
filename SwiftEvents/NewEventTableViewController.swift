//
//  NewEventTableViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/28/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit

class NewEventTableViewController: UITableViewController {

    private struct Constants {
        static let textCell = "TextCell"
        static let basicCell = "BasicCell"
        
        static let headers : [String] = ["Event Caption", "Start Time", "Finish Time"]
        
    }
    
    private var event = Event(name: "Quick Entry")
    private var timeZone = TimeZone.current
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 3
        case 3: return 1
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.textCell, for: indexPath) as! TextTableViewCell
            cell.eventText.text = event?.name
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell, for: indexPath)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let dateResult = DateEnum.displayDate(event?.startDate, timeZone: timeZone)
                cell.textLabel?.text = dateResult.caption
            } else if indexPath.row == 1 {
                let timeResult = DateEnum.displayTime(event?.startDate, timeZone: timeZone)
                cell.textLabel?.text = timeResult.caption
            }
            return cell
        }
        
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Show elapased Time"
            case 1:
                cell.textLabel?.text = event?.finish == DateEnum.dateWildCard
                    ? "End Date?" : DateEnum.displayDate(event?.finishDate, timeZone: timeZone).caption
            case 2:
                cell.textLabel?.text = event?.finish == DateEnum.dateWildCard
                    ? "End Time?" : DateEnum.displayTime(event?.finishDate, timeZone: timeZone).caption
            default:
                break
            }
            return cell
        }
        
        if indexPath.section == 3 {
            cell.textLabel?.text = "Save"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section < Constants.headers.count) ? Constants.headers[section] : nil
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
