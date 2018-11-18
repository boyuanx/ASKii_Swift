//
//  ClassRegisterViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/22/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SCLAlertView

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
        s.attributedPlaceholder = "Class Code".set(style: StringStyles.registrationTextField.rawValue)
        s.title = "Class Code"
        s.textAlignment = .center
        s.titleColor = SharedInfo.USC_redColor
        s.selectedTitleColor = SharedInfo.USC_redColor
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
        registerTextfield.resignFirstResponder()
        if let text = registerTextfield.text {
            if !text.isEmpty {
                GlobalLinearProgressBar.shared.start()
                sender.isUserInteractionEnabled = false
                NetworkingUtility.shared.registerClass(classID: text) { [weak self] (response) in
                    if (response == "Failed") {
                        self?.classCodeFormatAlert(message: "Class does not exist.")
                    } else if (response == "Added") {
                        self?.enrollSuccessAlert()
                    } else if (response == "") {
                        self?.enrollDuplicateAlert()
                    } else {
                        self?.classCodeFormatAlert(message: response)
                    }
                    sender.isUserInteractionEnabled = true
                    GlobalLinearProgressBar.shared.stop()
                }
            } else {
                classCodeFormatAlert(message: nil)
            }
        } else {
            classCodeFormatAlert(message: nil)
        }
        registerTextfield.text = ""
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
