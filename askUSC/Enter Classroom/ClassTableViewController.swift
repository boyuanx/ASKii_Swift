//
//  ClassTableViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/20/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

class ClassTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        classList = ["CSCI201"]
        instructorList = ["Jeffrey Miller"]
        descriptionList = ["Principles of Software Development"]
        initUI()
        tableViewInit()
    }
    
    var navigationTitle = "Enter Classroom"
    var classList = [String]()
    var instructorList = [String]()
    var descriptionList = [String]()
    var tableView: UITableView!
}

extension ClassTableViewController {
    
    func initUI() {
        // MARK: Navigation setup
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
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
        cell.name = classList[indexPath.row]
        cell.descript = descriptionList[indexPath.row]
        cell.instructor = instructorList[indexPath.row]
        cell.initUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SharedInfo.classListCellHeight
    }
    
}
