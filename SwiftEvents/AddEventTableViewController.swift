//
//  AddEventTableViewController.swift
//  SwiftEvents
//
//  Created by Steven Smith on 1/26/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import UIKit

class AddEventTableViewController: UITableViewController {
    
    private struct Constants {
        static let addEventCellIdentifier = "AddEventTableViewCell"
    }
    
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = (tableView.dequeueReusableCell(withIdentifier: Constants.addEventCellIdentifier, for: indexPath) as? AddEventTableViewCell)!
            cell.eventName = "Zerk"
            cell.startDate = "Zerk"
            cell.finishDate = "Zerk"
            //            cell.eventTextField.text = "Zerk"
            //            cell.finishButton.setTitle("Zerk", for: .normal)
            return cell
        default:
            let cell = (tableView.dequeueReusableCell(withIdentifier: Constants.addEventCellIdentifier, for: indexPath) as? AddEventTableViewCell)!
            return cell
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setTableViewHeight()
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    private func setTableViewHeight() {
        let height = self.tableView.rowHeight * 2.0
        var frame = self.tableView.frame
        frame.size.height = height
        self.tableView.frame = frame
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
