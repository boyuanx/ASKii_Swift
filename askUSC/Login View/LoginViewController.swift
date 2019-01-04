//
//  ViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/14/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import GoogleSignIn
import SideMenu

class LoginViewController: BaseViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GSignIn()
        initUI()
        SharedInfo.currentRootViewController = self
    }

    // MARK: Layout setup
    func initUI() {
        view.backgroundColor = UIColor(rgb: 0x991B1E)
        view.addSubview(USCLogo)
        USCLogo.translatesAutoresizingMaskIntoConstraints = false;
        USCLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        USCLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        USCLogo.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        USCLogo.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.width / 4).isActive = true
        view.addSubview(GoogleButton)
        GoogleButton.translatesAutoresizingMaskIntoConstraints = false;
        GoogleButton.topAnchor.constraint(equalTo: USCLogo.bottomAnchor, constant: 0).isActive = true;
        GoogleButton.centerXAnchor.constraint(equalTo: USCLogo.centerXAnchor).isActive = true;
        view.addSubview(guestButton)
        guestButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(GoogleButton.snp.bottom).offset(10)
            make.width.equalTo(GoogleButton.snp.width).offset(-10)
            make.height.equalTo(GoogleButton.snp.height).offset(-7)
        }
        guestButton.layer.cornerRadius = 5
        guestButton.addTarget(self, action: #selector(guestLoginAction(sender:)), for: .touchUpInside)
        
        // MARK: DEBUG ONLY
        view.addSubview(debugButton)
        debugButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(guestButton.snp.centerX)
            make.top.equalTo(guestButton.snp.bottom).offset(10)
        }
        debugButton.addTarget(self, action: #selector(debugBypass), for: .touchUpInside)
    }
    
    // MARK: Google Sign-in logic
    func GSignIn() {
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    // This gets called from AppDelegate
    func loginFailed() {
        loginFailureAlert(message: nil) {
            GIDSignIn.sharedInstance()?.signOut()
        }
    }
    
    func notUSCEmail() {
        loginFailureAlert(message: "Please use your @usc.edu email!") {
            GIDSignIn.sharedInstance()?.signOut()
        }
    }
    
    // MARK: USC Logo
    let USCLogo: UIImageView = {
        let i = UIImageView(image: UIImage(named: "USC_Banner"))
        i.contentMode = .scaleAspectFit
        i.clipsToBounds = true
        return i
    }()
    
    // MARK: Google Sign-in button
    let GoogleButton: GIDSignInButton = {
        let G = GIDSignInButton()
        return G
    }()
    
    // MARK: Guest Sign-in button
    let guestButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        b.setAttributedTitle("Guest Login".set(style: StringStyles.guestLogin.rawValue), for: .normal)
        return b
    }()
    
    @objc func guestLoginAction(sender: UIButton) {
        
        CoreInformation.shared.setUserID(ID: UUID().uuidString)
        CoreInformation.shared.setName(setFirst: true, name: "Guest")
        CoreInformation.shared.setName(setFirst: false, name: "")
        
        // Manual login procedure
        let sideMenuNavController = UISideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.menuLeftNavigationController = sideMenuNavController
        SideMenuManager.default.menuFadeStatusBar = false
        
        let homeVC = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        
        UIApplication.shared.keyWindow?.setWithAnimation(rootViewController: navigationController, with: .push)
        SharedInfo.currentRootViewController = homeVC
        SharedInfo.currentNavController = navigationController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    // MARK: DEBUG ONLY! OFFLINE LOGIN
    let debugButton: UIButton = {
        let b = UIButton()
        b.setTitle("DEBUG LOGIN", for: .normal)
        return b
    }()
    
    @objc func debugBypass() {
        CoreInformation.shared.setName(setFirst: true, name: "Jack")
        CoreInformation.shared.setName(setFirst: false, name: "Xu")
        
        let sideMenuNavController = UISideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.menuLeftNavigationController = sideMenuNavController
        SideMenuManager.default.menuFadeStatusBar = false
        
        let homeVC = ProfileViewController()
        homeVC.isDebug = true
        let navigationController = UINavigationController(rootViewController: homeVC)
        
        UIApplication.shared.keyWindow?.setWithAnimation(rootViewController: navigationController, with: .push)
        SharedInfo.currentRootViewController = homeVC
        SharedInfo.currentNavController = navigationController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }

}

