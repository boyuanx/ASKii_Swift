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
import Firebase

class SideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CoreInformation.shared.getName(getFirst: true) == "Guest") {
            menuItems = ["My Profile", "Class Registration"]
        }
        
        initUI()
        tableViewSetup()
    }

    // MARK: - Table view data source
    var menuItems = ["My Profile", "Office Hour Helper", "Enter Classroom", "Attendance History", "Class Registration", "Clear Cache"]
    var disabledMenuItems = [""]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)
        let currentItemTitle = menuItems[indexPath.row]
        if (disabledMenuItems.contains(currentItemTitle)) {
            cell.textLabel?.attributedText = currentItemTitle.set(style: StringStyles.menuItemDisabled.rawValue)
            cell.isUserInteractionEnabled = false
        } else {
            cell.textLabel?.attributedText = currentItemTitle.set(style: StringStyles.menuItem.rawValue)
        }
        if (currentItemTitle == "Clear Cache") {
            cell.textLabel?.attributedText = menuItems[indexPath.row].set(style: StringStyles.menuItemDestructive.rawValue)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTitle = menuItems[indexPath.row]
        if (selectedTitle == "Enter Classroom" && !isViewControllerInStack(vc: ClassTableViewController.self)) {
            SideMenuManager.default.dismissSideMenuAndSwitchRootTo(ViewController: ClassTableViewController())
        } else if (selectedTitle == "My Profile" && !isViewControllerInStack(vc: ProfileViewController.self)) {
            SideMenuManager.default.dismissSideMenuAndSwitchRootTo(ViewController: ProfileViewController())
        } else if (selectedTitle == "Office Hour Helper" && !isViewControllerInStack(vc: OHelperTableViewController.self)) {
            SideMenuManager.default.dismissSideMenuAndSwitchRootTo(ViewController: OHelperTableViewController())
        } else if (selectedTitle == "Class Registration" && !isViewControllerInStack(vc: ClassRegisterViewController.self)) {
            SideMenuManager.default.dismissSideMenuAndSwitchRootTo(ViewController: ClassRegisterViewController())
        } else if (selectedTitle == "Attendance History" && !isViewControllerInStack(vc: AttendanceClassTableViewController.self)) {
            SideMenuManager.default.dismissSideMenuAndSwitchRootTo(ViewController: AttendanceClassTableViewController())
        } else if (selectedTitle == "Clear Cache") {
            clearCacheAlert()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SharedInfo.menuCellHeight;
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let logOutString: NSMutableAttributedString = {
            let s = "Log Out".set(style: StringStyles.logOut.rawValue)!
            return s
        }()
        let logOutBtn: UIButton = {
            let b = UIButton()
            b.addTarget(self, action: #selector(logOut), for: .touchUpInside)
            b.setAttributedTitle(logOutString, for: .normal)
            b.layer.cornerRadius = 5
            b.layer.borderColor = SharedInfo.USC_redColor.cgColor
            b.layer.borderWidth = 0.5
            return b
        }()
        let footer: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.clear
            v.addSubview(logOutBtn)
            logOutBtn.snp.makeConstraints({ (make) in
                make.centerX.equalTo(v.snp.centerX)
                make.bottom.equalTo(v.snp.bottom).offset(-10)
                make.width.equalTo(v.snp.width).offset(-40)
            })
            return v
        }()
        return footer
    }
    
    // MARK: Calculates the gap between the end of the last cell and the end of the tableView
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height)! - CGFloat(menuItems.count * 40) - (navigationController?.navigationBar.frame.height)!
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
    
    @objc func logOut() {
        GIDSignIn.sharedInstance()?.signOut()
        try? Auth.auth().signOut()
        CoreInformation.shared.resetAll()
        DiskManager.classMessageMap = [String: [Message]]()
        UIApplication.shared.keyWindow?.setWithAnimation(rootViewController: LoginViewController(), with: nil)
    }
    
}
