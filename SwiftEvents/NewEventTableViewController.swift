//
//  NewEventTableViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/28/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit
import SwiftyPickerPopover
import ExpandableDatePicker

class NewEventTableViewController: UITableViewController, ExpandableDatePicker {
    
    private struct Constants {
        static let textCell = "TextCell"
        static let basicCell = "BasicCell"
        static let captionCell = "CaptionCell"
        
        static let sectionHeaders = ["Event Caption", "Start Time", "End Time"]
        static let sectionEvent = 0
        static let sectionStart = 1
        static let sectionEnd = 2
        static let rowEventCaption = IndexPath(row: 0, section: 0)
        static let rowStartDate = IndexPath(row: 0, section: 1)
        static let rowStartTime = IndexPath(row: 1, section: 1)
        static let rowStartTimeZone = IndexPath(row: 2, section: 1)
        static let rowEndIntervalOption = IndexPath(row: 3, section: 1)
        static let rowEndDate = IndexPath(row: 0, section: 2)
        static let rowEndTime = IndexPath(row: 1, section: 2)
        static let rowEndTimeZone = IndexPath(row: 2, section: 2)
    }
    
    // Part of ExpandableDatePicker protocol
    var edpIndexPath: IndexPath?
    var edpShowTimeZoneRow: Bool = true
    
    fileprivate var selectedDate = Date()
    fileprivate var selectedTimeZone = TimeZone.autoupdatingCurrent
    
    private var event = Event(name: "Quick Entry")!
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Constants.sectionEvent: return 1
        case Constants.sectionStart: return 3
        case Constants.sectionEnd: return 4
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Constants.sectionEvent:
            return eventCell(indexPath: indexPath)
        case Constants.sectionStart:
            return startCells(indexPath: indexPath)
        case Constants.sectionEnd:
            return endCells(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Constants.sectionEvent:
            return
        case Constants.sectionStart:
            selectStartCells(at: indexPath)
            return
        default:
            return
        }
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            DatePickerPopover.appearFrom(originView: (cell?.contentView)!, baseViewController: self, title: "Clearable DatePicker", dateMode: .date, initialDate: Date(), doneAction: { selectedDate in print("selectedDate \(selectedDate)")}, cancelAction: {print("cancel")},clearAction: { print("clear")})
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section < Constants.sectionHeaders.count) ? Constants.sectionHeaders[section] : nil
    }
    
    /// Create cell to display the event caption
    private func eventCell(indexPath: IndexPath) -> TextTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.textCell, for: indexPath) as! TextTableViewCell
        cell.eventText.text = event.name
        return cell
    }
    
    /// Create cells for the Start Time information
    private func startCells(indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case Constants.rowStartDate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = "Start Date"
            cell.detailTextLabel?.text = event.startAs(.date)
            return cell
        case Constants.rowStartTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = "Start Time"
            cell.detailTextLabel?.text = event.startAs(.time)
            return cell
        case Constants.rowStartTimeZone:
            return ExpandableDatePickerTimeZoneCell.reusableCell(for: indexPath, in: tableView, timeZone: event.startTimeZone.asTimeZone!)
        default:
            return UITableViewCell()
        }
    }
    
    /// Called when a cell in the Start Time section is selected
    private func selectStartCells(at indexPath: IndexPath) {
        switch indexPath {
        case Constants.rowStartTimeZone:
            let viewController = ExpandableDatePickerTimeZoneTableViewController {
                [weak self] timeZone in
                print("\(timeZone.localizedName(for: NSTimeZone.NameStyle.shortGeneric, locale: Locale.current))")
                print("\(timeZone.localizedName(for: NSTimeZone.NameStyle.generic, locale: Locale.current))")
                print("\(timeZone.localizedName(for: NSTimeZone.NameStyle.standard, locale: Locale.current))")
                print("\(timeZone.localizedName(for: NSTimeZone.NameStyle.shortStandard, locale: Locale.current))")
                let v = timeZone.identifier
                let tzString = timeZone.localizedName(for: NSTimeZone.NameStyle.shortStandard, locale: Locale.current)
                if let t = tzString?.asTimeZone {
                    print("\(t)")
                }
                
                print("\(timeZone.localizedName(for: NSTimeZone.NameStyle.standard, locale: Locale.current))")
                self?.event.startTimeZone = timeZone.identifier
                self?.selectedTimeZone = timeZone
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            self.navigationController!.pushViewController(viewController, animated: true)
            return
        default:
            return
        }
    }
    
    private func showTimeZonePicker(indexPath: IndexPath) {
        let viewController = ExpandableDatePickerTimeZoneTableViewController {
            [weak self] timeZone in
            self?.selectedTimeZone = timeZone
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.navigationController!.pushViewController(viewController, animated: true)
        return
    }
    
    private func endCells(indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case Constants.rowEndIntervalOption:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = "Intervals since start"
            cell.textLabel?.textAlignment = .center
            return cell
        case Constants.rowEndDate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = "End Date"
            cell.detailTextLabel?.text = (event.finish == Formats.wildCard) ? "Real Date" : event.finishAs(.date)
            return cell
        case Constants.rowEndTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCell) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = "End Time"
            cell.detailTextLabel?.text = (event.finish == Formats.wildCard) ? "Real Time" : event.finishAs(.time)
            return cell
        case Constants.rowEndTimeZone:
            return ExpandableDatePickerTimeZoneCell.reusableCell(for: indexPath, in: tableView, timeZone: selectedTimeZone)
            
        default:
            return UITableViewCell()
        }
    }
    
    private func selectEndCells(at indexPath: IndexPath) {
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
