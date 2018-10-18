//
//  HomeViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SideMenu
import SnapKit
import SkeletonView

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        runOnce()
        initUI()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    // MARK: Title of navigation bar here:
    var navigationTitle = "Profile"
    
    // MARK: Profile image
    let profileImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "USC_Placeholder1"))
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        i.layer.borderWidth = 0.5
        i.layer.borderColor = UIColor.lightGray.cgColor
        i.isSkeletonable = true
        return i
    }()
}

extension HomeViewController {
    
    func runOnce() {
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    func initUI() {
        
        // MARK: Navigation setup
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        // MARK: Autolayout
        view.addSubview(profileImgView)
        profileImgView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(view.snp.width).dividedBy(2)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(40)
        }
        view.layoutIfNeeded()
        profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
        
        // MARK: SkeletonView
        //view.showAnimatedGradientSkeleton()
    }
    
}
