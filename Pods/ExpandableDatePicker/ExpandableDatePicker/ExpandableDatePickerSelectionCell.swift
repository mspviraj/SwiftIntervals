//
//  ExpandableDatePickerSelectionCell.swift
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

import UIKit

/// A custom `UITableViewCell` which is used to show the row which expands into a 
/// `UIDatePicker` and time zone selection cell.
open class ExpandableDatePickerSelectionCell : UITableViewCell, ShowsDatePicker {
    /// The identifier for the cell.  Only necessary if you are overriding registration with a subclass.
    public static let identifier = "0DB89E55-CAB1-4EFB-8D47-01C86D52B106"

    /// :nodoc:
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: ExpandableDatePickerSelectionCell.identifier)

        textLabel!.text = NSLocalizedString("Date:", comment: "The date label for a table cell that selects the date")
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns a reusable cell to display the time zone picker row.
    ///
    /// - Parameters:
    ///   - indexPath: The `IndexPath` where the cell will be displayed.
    ///   - tableView: The `UITableView` being used.
    /// - Returns: An `ExpandableDatePickerSelectionCell`
    open class func reusableCell(for indexPath: IndexPath, in tableView: UITableView) -> ExpandableDatePickerSelectionCell {
        return tableView.dequeueReusableCell(withIdentifier: ExpandableDatePickerSelectionCell.identifier, for: indexPath) as! ExpandableDatePickerSelectionCell
    }
}
