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
        sideMenuGestureSetup()
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
    
    // TODO: NEEDS CONVERSION TO FIREBASE
    @objc func registerAction(sender: UIButton) {
        registerTextfield.resignFirstResponder()
        if let text = registerTextfield.text {
            if !text.isEmpty {
                GlobalLinearProgressBar.shared.start()
                sender.isUserInteractionEnabled = false
                if (CoreInformation.shared.getName(getFirst: true) != "Guest") {
                    /*
                    NetworkingUtility.shared.registerClass(classID: text) { [weak self] (response) in
                        if (response == "Failed") {
                            self?.classCodeFormatAlert(message: "Class does not exist.")
                        } else if (response == "Added") {
                            let alert = self?.refreshingClassAlert()
                            NetworkingUtility.shared.getClasses { [weak self] (classes) in
                                SharedInfo.classList = classes
                                self?.dismissAlert(alert: alert!)
                                self?.enrollSuccessAlert()
                            }
                        } else if (response == "") {
                            self?.enrollDuplicateAlert()
                        } else {
                            self?.classCodeFormatAlert(message: response)
                        }
                        sender.isUserInteractionEnabled = true
                        GlobalLinearProgressBar.shared.stop()
                    }
                    */
                    //FirebaseUtility.shared.registerClass(user: <#T##User#>, classID: <#T##String#>, completion: <#T##(String?) -> Void#>)
                } else {
                    /*
                    NetworkingUtility.shared.guestEnterClass(classID: text) { [weak self] (guestClass) in
                        GlobalLinearProgressBar.shared.stop()
                        sender.isUserInteractionEnabled = true
                        if let guestClass = guestClass {
                            let destinationVC = ClassroomChatTableViewController()
                            destinationVC.thisClass = guestClass
                            destinationVC.initNavBar(withTitle: nil, withClass: destinationVC.thisClass)
                            destinationVC.reloadData(withAnimation: false, insertSections: false)
                            self?.navigationController?.pushViewController(destinationVC, animated: true)
                        } else {
                            self?.classCodeFormatAlert(message: "The class code you've entered is invalid.")
                        }
                    }
                    */
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
