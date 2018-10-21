//
//  BaseViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SideMenu

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseUI()
        initNavigationBar()
    }
    
}

extension BaseViewController {
    func initBaseUI() {
        view.backgroundColor = UIColor.white;
    }
    func initNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: .plain, target: self, action: #selector(presentSideMenu))
        leftButton.tintColor = UIColor.white
        navigationItem.setLeftBarButton(leftButton, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor(rgb: SharedInfo.USC_redColor)
    }
    @objc func presentSideMenu() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: {
        })
    }
}
