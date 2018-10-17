//
//  HomeViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brown

        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false

        
        
        
        //self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    


}
