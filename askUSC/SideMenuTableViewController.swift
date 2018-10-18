//
//  SideMenuTableViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/17/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SideMenu
import SwiftRichString
import GoogleSignIn

class SideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        tableViewSetup()
        
    }

    // MARK: - Table view data source
    var menuItems = ["My Profile", "Enter Classroom", "Office Hours", "Log Out"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (menuItems[indexPath.row] == "Log Out") {
            GIDSignIn.sharedInstance()?.signOut()
            switchRootVC(target: LoginViewController(), navigation: false)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
}

extension SideMenuTableViewController {
    
    func initUI() {
        // Navigation Bar Setup
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x991B1E)
        let navTitle = "Welcome back, ".set(style: StringStyles.welcome.rawValue)!
        navTitle.append(CoreInformation.shared.getName(getFirst: true).set(style: StringStyles.name.rawValue)!)
        navTitle.append("!".set(style: StringStyles.welcome.rawValue)!)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navLabel.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = navLabel
        
        // Side Menu Config
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        //SideMenuManager.default.menuBlurEffectStyle = UIBlurEffect.Style.regular
    }
    func tableViewSetup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menu")
        tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor.clear
    }
}
