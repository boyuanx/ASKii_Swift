//
//  ClassTableViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/20/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import CoreLocation

class ClassTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        tableViewInit()
        fetchData()
    }
    
    let navigationTitle = "Enter Classroom"
    var classList = [Class]()
    var tableView: UITableView!
    
    func initUI() { // Here because Swift does not allow children to override non-objC extensions
        // MARK: Navigation setup
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
    }
}

extension ClassTableViewController {
    
    func fetchData() {
        NetworkingUtility.shared.getClasses { [weak self] (classes) in
            self?.classList = classes
            self?.tableView.reloadSections(NSIndexSet(indexesIn: NSMakeRange(0, (self?.tableView.numberOfSections)!)) as IndexSet, with: .automatic)
        }
    }
    
    func tableViewInit() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ClassTableViewCell.self, forCellReuseIdentifier: "class")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "class", for: indexPath) as! ClassTableViewCell
        let thisClass = classList[indexPath.row]
        
        if (!thisClass.isCurrentlyInSession()) {
            //cell.isUserInteractionEnabled = false
            //cell.backgroundColor = UIColor.lightGray
        }
        
        cell.name = thisClass.className
        cell.descript = thisClass.classDescription
        cell.instructor = thisClass.classInstructor
        cell.initUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let thisClass = classList[indexPath.row]
        var shouldContinue = false
        NetworkingUtility.shared.tryCheckIn(thisClass: thisClass) { [weak self] (response) in
            if (response == "Not in session.") {
                self?.checkInFailureAlert(message: "Class is not in session.")
            } else if (response == "Location failed.") {
                self?.checkInFailureAlert(message: "You are not physically in class!")
            } else if (response == "Failed") {
                self?.checkInFailureAlert(message: "Check-in has failed due to a possible connection issue.")
            } else if (response == "Success") {
                self?.checkInSuccessAlert(message: "You have successfully checked in.")
                shouldContinue = true
            } else if (response == "Already checked in.") {
                self?.checkInSuccessAlert(message: "You have already checked in.")
                shouldContinue = true
            }
        }
        
        if (!shouldContinue) {
            return
        }
        
        let destination = ClassroomChatTableViewController()
        destination.thisClass = thisClass
        destination.initNavBar(withTitle: nil, withClass: destination.thisClass)
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SharedInfo.classListCellHeight
    }

    
}
