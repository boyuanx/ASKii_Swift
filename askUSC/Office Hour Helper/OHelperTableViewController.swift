//
//  OHelperTableViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 1/4/19.
//  Copyright © 2019 Boyuan Xu. All rights reserved.
//

import UIKit

class OHelperTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let navigationTitle = "OHelper"
    var tableView: UITableView!
    var queueList = [OfficeHourQueue]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        tableViewInit()
        fetchData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queueList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SharedInfo.classListCellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OHList", for: indexPath) as! OHelperTableViewCell
        cell.initCell(OHQ: queueList[indexPath.row])
        cell.initUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension OHelperTableViewController {
    
    func fetchData() {
        debugData()
    }
    
    private func debugData() {
        let testQueue = OfficeHourQueue()
        queueList.append(testQueue)
    }
    
    func tableViewInit() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OHelperTableViewCell.self, forCellReuseIdentifier: "OHList")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func initUI() {
        // MARK: Navigation setup
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        let navRightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(enterOHQueue(sender:)))
        navRightBtn.tintColor = .white
        navigationItem.setRightBarButton(navRightBtn, animated: true)
    }
    
    @objc private func enterOHQueue(sender: Any) {
        navigationController?.pushViewController(OHelperEnterQueueViewController(), animated: true)
    }
    
}
