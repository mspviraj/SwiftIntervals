//
//  NewEventTableViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/28/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit
import ExpandableDatePicker
import SwiftyPickerPopover

class NewEventTableViewController: UITableViewController, ExpandableDatePicker {
    
    private struct Constants {
        static let textCell = "TextCell"
        static let basicCell = "BasicCell"
        static let captionCell = "CaptionCell"
        enum cellPurpose : Int {
            case eventCaption = 0
            case eventTextField
            case startCaption
            case startingDate
            case startingTime
            case endCaption
            case elapsedOption
            case endingDate
            case endingTime
            case submit
        }
    }
    
    var edpIndexPath: IndexPath?
    var edpShowTimeZoneRow: Bool = true
    
    fileprivate var rowThatTogglesDatePicker: Int!
    
    fileprivate var selectedDate = Date()
    fileprivate var selectedTimeZone = TimeZone.autoupdatingCurrent
    
    private var event = Event(name: "Quick Entry")
    private var timeZone = TimeZone.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.registerExpandableDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 + edpDatePickerRowsShowing
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if edpShouldShowDatePicker(at: indexPath) {
            let cell = ExpandableDatePickerCell.reusableCell(for: indexPath, in: tableView)
            let mode : UIDatePickerMode = (indexPath.row == 3 || indexPath.row == 7) ? .date : .time
            cell.datePicker.datePickerMode = mode
            cell.onDateChanged = {
                [unowned self] date in
                self.selectedDate = date
                self.tableView.reloadRows(at: [self.edpLabelIndexPath!], with: .automatic)
            }
            
            cell.datePicker.date = selectedDate
            
            return cell
        } else if edpShouldShowTimeZoneRow(at: indexPath) {
            return ExpandableDatePickerTimeZoneCell.reusableCell(for: indexPath, in: tableView, timeZone: selectedTimeZone)
        }
        
        if indexPath.row == Constants.cellPurpose.eventCaption.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.captionCell, for: indexPath)
            cell.textLabel?.text = "Event Caption"
            return cell
        }
        
        if indexPath.row == Constants.cellPurpose.eventTextField.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.textCell, for: indexPath) as! TextTableViewCell
            cell.textLabel?.text = event?.name
            return cell
        }
        
        if indexPath.row == Constants.cellPurpose.startCaption.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.captionCell, for: indexPath)
            cell.textLabel?.text = "Start Time"
            return cell
        }
        
        if indexPath.row == Constants.cellPurpose.startingDate.rawValue {
            let dateCell = ExpandableDatePickerSelectionCell.reusableCell(for: indexPath, in: tableView)
            dateCell.textLabel?.textAlignment = .center
            let dateResult = DateEnum.displayDate(event?.startDate, timeZone: timeZone)
            dateCell.textLabel?.text = dateResult.caption
            return dateCell
        }
        
        if indexPath.row == Constants.cellPurpose.startingTime.rawValue {
            let timeCell = ExpandableDatePickerSelectionCell.reusableCell(for: indexPath, in: tableView)
            timeCell.textLabel?.textAlignment = .right
            let timeResult = DateEnum.displayTime(event?.startDate, timeZone: timeZone)
            timeCell.textLabel?.text = timeResult.caption
            return timeCell
        }
        
        if indexPath.row == Constants.cellPurpose.endCaption.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.captionCell, for: indexPath)
            cell.textLabel?.text = "Finish Time"
            return cell
        }
        
        if indexPath.row == Constants.cellPurpose.elapsedOption.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell, for: indexPath)
            cell.textLabel?.text = "Show Elapsed Time"
            return cell
        }
        
        if indexPath.row == Constants.cellPurpose.endingDate.rawValue {
            let cell = ExpandableDatePickerSelectionCell.reusableCell(for: indexPath, in: tableView)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = event?.finish == DateEnum.dateWildCard
                ? "End Date?" : DateEnum.displayDate(event?.finishDate, timeZone: timeZone).caption
            return cell
        }
        if indexPath.row == Constants.cellPurpose.endingTime.rawValue {
            let cell = ExpandableDatePickerSelectionCell.reusableCell(for: indexPath, in: tableView)
            cell.textLabel?.text = event?.finish == DateEnum.dateWildCard
                ? "End Time?" : DateEnum.displayTime(event?.finishDate, timeZone: timeZone).caption
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell, for: indexPath)
        if indexPath.row == Constants.cellPurpose.submit.rawValue {
            cell.textLabel?.text = "Submit"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            DatePickerPopover.appearFrom(originView: (cell?.contentView)!, baseViewController: self, title: "Clearable DatePicker", dateMode: .date, initialDate: Date(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")},clearAction: { print("clear")})
            return
        }
        switch indexPath.row {
        case Constants.cellPurpose.startingDate.rawValue :
            edpShowTimeZoneRow = false
        case Constants.cellPurpose.endingDate.rawValue:
            edpShowTimeZoneRow = false
        default:
            edpShowTimeZoneRow = true
        }
        guard let modelIndexPath = edpTableCellWasSelected(at: indexPath) else {
            // If tableCellWasSelected(at:) returns nil, they clicked on the time zone selector row.
            let vc = ExpandableDatePickerTimeZoneTableViewController {
                [unowned self] timeZone in
                self.selectedTimeZone = timeZone
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            navigationController!.pushViewController(vc, animated: true)
            
            return
        }
        
        print("\(modelIndexPath)")
        
        // modelIndexPath is the new indexPath you use for which row was selected.
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
