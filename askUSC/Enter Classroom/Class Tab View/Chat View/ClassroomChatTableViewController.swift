//
//  ClassroomChatTableViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/2/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import Disk

class ClassroomChatTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        readCache()
    }
    
    var dateMessageGroup = [DateMessageGroup]()
    var messageCacheExists = false
}

extension ClassroomChatTableViewController {
    
    func readCache() {
        
    }
    
    func initTableView() {
        tableView.register(ClassroomTableCell.self, forCellReuseIdentifier: "Message")
        tableView.separatorColor = UIColor.clear
    }
    
}

extension ClassroomChatTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dateMessageGroup.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ClassroomChatSectionHeaderView()
        header.initUI(date: dateMessageGroup[section].date)
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateMessageGroup[section].messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath) as! ClassroomTableCell
        let message = dateMessageGroup[indexPath.section].messages[indexPath.row]
        cell.initUI(message: message)
        return cell
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

}
