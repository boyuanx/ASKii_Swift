//
//  ClassroomChatTableViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/2/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import Disk
import InputBarAccessoryView
import SwiftDate

protocol ChatTableViewDelegate: class {
    func receiveChatMessage(message: Message)
}

class ClassroomChatTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TEST
//        let message = Message(type: "text", data: "Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? Am I a PhD? ", sender: "Jeffrey Miller", classID: "CSCI-201", voters: ["a", "b"], messageID: nil)
//        var dmg1 = DateMessageGroup(date: Date() - 3.days)
//        dmg1.messages.append(message)
//        dateMessageGroupArray.append(dmg1)
        // END TEST
        NetworkingUtility.shared.delegate = self
        initTableView()
        initInputBar()
        initNavBarWithTintColor(withButtonColor: .white)
        NetworkingUtility.shared.connectToChatSocket(classID: thisClass.classID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkingUtility.shared.disconnectFromChatSocket()
    }
    
    var thisClass: Class!
    var dateMessageGroupArray = [DateMessageGroup]()
    var messageCacheExists = false
    
    // MARK: Input bar setup
    let inputBar = InputBarAccessoryView()
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension ClassroomChatTableViewController {
    
    func initTableView() {
        tableView.register(ClassroomTableCell.self, forCellReuseIdentifier: "Message")
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.keyboardDismissMode = .interactive
    }
    
    func initInputBar() {
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .webSearch
    }
    
}

extension ClassroomChatTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dateMessageGroupArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ClassroomChatSectionHeaderView()
        header.initUI(date: dateMessageGroupArray[section].date)
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateMessageGroupArray[section].messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath) as! ClassroomTableCell
        let message = dateMessageGroupArray[indexPath.section].messages[indexPath.row]
        cell.initUI(message: message)
        return cell
    }

}

extension ClassroomChatTableViewController: InputBarAccessoryViewDelegate {
    // MARK: InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(type: MessageType.NewMessage.rawValue, data: text, sender: CoreInformation.shared.getUserID(), classID: thisClass.classID, voters: [CoreInformation.shared.getUserID()], messageID: nil)
        NetworkingUtility.shared.writeMessageToChatSocket(message: message)
        inputBar.inputTextView.text = ""
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        tableView.contentInset.bottom = size.height
    }
    
}

extension ClassroomChatTableViewController: ChatTableViewDelegate {
    // MARK: Web socket interface
    func receiveChatMessage(message: Message) {
        print("Delegate!")
        print(message)
        do {
            try DiskManager.shared.appendNewMessage(message: message)
            reloadData()
        } catch {
            IOErrorAlert(message: "I/O error code: appNM. Please make sure the app has sufficient permission to write. Try re-launching the application and/or clearing application data.")
        }
    }
    
    func reloadData() {
        if let array = DiskManager.shared.getDateMessageGroupsForClass(classID: thisClass.classID) {
            dateMessageGroupArray = array
        } else {
            dateMessageGroupArray = [DateMessageGroup]()
        }
    
        tableView.reloadData()
        
//        let range = NSMakeRange(0, tableView.numberOfSections)
//        let sections = NSIndexSet(indexesIn: range)
//        tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
}
