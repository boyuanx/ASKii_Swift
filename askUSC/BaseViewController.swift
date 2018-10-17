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
        view.backgroundColor = UIColor(rgb: 0x991B1E)
    }
    func initNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: .plain, target: self, action: #selector(presentSideMenu))
        navigationItem.setLeftBarButton(leftButton, animated: false)
    }
    @objc func presentSideMenu() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    func dismissSideMenu() {
        dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController {
    
}
