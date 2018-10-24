//
//  ClassRegisterViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/22/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ClassRegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    // MARK: Navigation Title
    let navigationTitle = "Registration"
    
    // MARK: Registration text field
    let registerTextfield: SkyFloatingLabelTextField = {
        let s = SkyFloatingLabelTextField()
        s.placeholder = "Class Code"
        s.title = "Class Code"
        s.textAlignment = .center
        return s
    }()
    
    // MARK: Registration button
    let registerButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(registerAction(sender:)), for: .touchUpInside)
        b.setAttributedTitle("Enter".set(style: StringStyles.profileUpvoteButton.rawValue), for: .normal)
        b.backgroundColor = SharedInfo.USC_redColor
        return b
    }()
    @objc func registerAction(sender: UIButton) {
        print(registerTextfield.text ?? "0")
    }
    
}

extension ClassRegisterViewController {
    
    func initUI() {
        
        // MARK: Navigation setup
        let navTitle = navigationTitle.set(style: StringStyles.name.rawValue)
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        // MARK: Autolayout
        view.addSubview(registerTextfield)
        registerTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.equalToSuperview().dividedBy(3)
        }
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(registerTextfield.snp.bottom).offset(10)
            make.width.equalTo(registerTextfield.snp.width).offset(-20)
        }
        registerButton.layoutIfNeeded()
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
    }
    
}
