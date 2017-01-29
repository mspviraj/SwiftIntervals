//
//  ExpandableDatePickerTimeZoneTableViewController.swift
//
//  Copyright © 2016 Gargoyle Software, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

/// A `UITableViewController` which allows selection of a time zone based on either
/// an abbreviated name (e.g. PST) or a full name (e.g. America/Los_Angeles).  Supports
/// searching.
public class ExpandableDatePickerTimeZoneTableViewController : UITableViewController {
    fileprivate let onChosen: (TimeZone) -> Void

    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var longTimeZoneDelegate: LongTimeZoneDelegate?
    fileprivate var shortTimeZoneDelegate: ShortTimeZoneDelegate?

    private let segmentTintColor: UIColor?

    /// Designated initializer.
    ///
    /// - Parameters:
    ///   - segmentTintColor: The tint color to use for the segment picker added to the navigation bar
    ///   - onTimeZoneChosen: The method to call when a time zone is selected.
    public init(segmentTintColor: UIColor? = nil, onTimeZoneChosen: @escaping (TimeZone) -> Void) {
        self.onChosen = onTimeZoneChosen
        self.segmentTintColor = segmentTintColor

        super.init(style: .plain)
    }

    /// :nodoc:
    public override func viewDidLoad() {
        super.viewDidLoad()

        let segment = UISegmentedControl(items: [
            NSLocalizedString("Full", comment: "Segment title for displaying full timezone names."),
            NSLocalizedString("Abbrev", comment: "Segment title for displaying abbreviated timezone names.")
            ])
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentValueChanged(segment:)), for: .valueChanged)

        if let segmentTintColor = segmentTintColor {
            segment.tintColor = segmentTintColor
        }

        navigationItem.titleView = segment

        searchController.dimsBackgroundDuringPresentation = false

        definesPresentationContext = true

        tableView.tableHeaderView = searchController.searchBar

        perform(#selector(segmentValueChanged(segment:)), with: segment)
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func segmentValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: LongTimeZoneDelegate.identifier)

            longTimeZoneDelegate = LongTimeZoneDelegate(tableView: tableView, searchController: searchController, navigationController: navigationController, onChosen: onChosen)
            tableView.dataSource = longTimeZoneDelegate
            tableView.delegate = longTimeZoneDelegate
            searchController.searchResultsUpdater = longTimeZoneDelegate

            shortTimeZoneDelegate = nil
        } else {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: ShortTimeZoneDelegate.identifier)

            shortTimeZoneDelegate = ShortTimeZoneDelegate(tableView: tableView, searchController: searchController, navigationController: navigationController, onChosen: onChosen)
            tableView.dataSource = shortTimeZoneDelegate
            tableView.delegate = shortTimeZoneDelegate
            searchController.searchResultsUpdater = shortTimeZoneDelegate

            longTimeZoneDelegate = nil
        }

        tableView.reloadData()

        let searchBarFrame = searchController.searchBar.frame
        tableView.scrollRectToVisible(searchBarFrame, animated: false)
    }
}

