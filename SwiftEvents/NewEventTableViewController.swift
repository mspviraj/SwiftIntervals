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
        static let rowEndIntervalOption = IndexPath(row: 0, section: 2)
        static let rowEndDate = IndexPath(row: 1, section: 2)
        static let rowEndTime = IndexPath(row: 2, section: 2)
        static let rowEndTimeZone = IndexPath(row: 3, section: 2)
    }
    
    // Part of ExpandableDatePicker protocol
    var edpIndexPath: IndexPath?
    var edpShowTimeZoneRow: Bool = true
    
    fileprivate var selectedDate = Date()
    fileprivate var selectedTimeZone = TimeZone.autoupdatingCurrent
    
    private var event = Event(name: "Quick Entry")!
    private var timeZone = TimeZone.current
    
    
    private var endedTime : String? = nil
    private var endedDate : String? = nil
    private var endedTimeZone : String? = nil
    private var timer : Timer? = nil
    private var endBlockCaption : String = "--:--"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.registerExpandableDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
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
        case Constants.sectionEnd:
            selectEndCells(at: indexPath)
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
            return ExpandableDatePickerTimeZoneCell.reusableCell(for: indexPath, in: tableView, timeZone: event.startingTimeZone.asTimeZone!)
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
                self?.event.startingTimeZone = timeZone.identifier
                self?.selectedTimeZone = timeZone
                self?.tableView.reloadRows(at: [Constants.rowStartDate, Constants.rowStartTime, indexPath], with: .automatic)
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
            cell.detailTextLabel?.text = endBlockCaption
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
        stopTimer()
        switch indexPath {
        case Constants.rowEndIntervalOption:
            startTimer()
            return
        case Constants.rowEndTimeZone:
            let viewController = ExpandableDatePickerTimeZoneTableViewController {
                [weak self] timeZone in
                self?.event.finishingTimeZone = timeZone.identifier
                self?.selectedTimeZone = timeZone
                self?.tableView.reloadRows(at: [Constants.rowEndDate, Constants.rowEndTimeZone, indexPath], with: .automatic)
                self?.endedTimeZone = timeZone.identifier
            }
            self.navigationController!.pushViewController(viewController, animated: true)
            return
        default:
            return
        }
    }
    
    private func startTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        endedDate = nil
        endedTime = nil
        endedTimeZone = nil
        timer = Timer.init(fire: Date(), interval: 1.0, repeats: true) { (timer) in
            self.endBlockCaption = self.event.publishInterval(.progressive)
            self.tableView.reloadRows(at: [Constants.rowEndIntervalOption], with: .automatic)
        }
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
        reloadEndCells()
    }
    
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        endBlockCaption = "--:--"
        reloadEndCells()
    }
    
    private func reloadEndCells() {
        self.tableView.reloadRows(at: [Constants.rowEndIntervalOption, Constants.rowEndTime, Constants.rowEndTimeZone, Constants.rowEndDate], with: .automatic)
    }
}
