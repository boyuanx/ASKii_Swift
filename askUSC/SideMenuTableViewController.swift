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

class SideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        tableViewSetup()
    }

    // MARK: - Table view data source
    var menuItems = ["Enter Classroom", "Office Hours", "Log Out"]
    
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
}

extension SideMenuTableViewController {
    func initUI() {
        // Navigation Bar Setup
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x991B1E)
//        let welcomeStyle = Style {
//            $0.font = SystemFonts.GillSans_Light.font(size: 30)
//            $0.color = UIColor(rgb: 0xFFCC00)
//        }
//        let nameStyle = Style {
//            $0.font = SystemFonts.GillSans.font(size: 30)
//            $0.color = UIColor.white
//        }
        let navTitle = "Welcome back, ".set(style: "welcomeStyle")!
        navTitle.append(CoreInformation.shared.getName(getFirst: true).set(style: "nameStyle")!)
        navTitle.append("!".set(style: "welcomeStyle")!)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navLabel.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = navLabel
        // Side Menu Config
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuParallaxStrength = 5;
        //SideMenuManager.default.menuBlurEffectStyle = UIBlurEffect.Style.regular
    }
    func tableViewSetup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menu")
    }
}
