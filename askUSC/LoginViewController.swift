//
//  ViewController.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/14/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: BaseViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GSignIn()
        initUI()
    }
    
    // MARK: Layout setup
    func initUI() {
        view.addSubview(USCLogo)
        USCLogo.translatesAutoresizingMaskIntoConstraints = false;
        USCLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        USCLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        USCLogo.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        USCLogo.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.width / 4).isActive = true
        view.addSubview(GoogleButton)
        GoogleButton.translatesAutoresizingMaskIntoConstraints = false;
        GoogleButton.topAnchor.constraint(equalTo: USCLogo.bottomAnchor, constant: 0).isActive = true;
        //GoogleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true;
        GoogleButton.centerXAnchor.constraint(equalTo: USCLogo.centerXAnchor).isActive = true;
    }
    
    // MARK: Google Sign-in logic
    func GSignIn() {
        GIDSignIn.sharedInstance().uiDelegate = self
        if (CoreInformation.shared.getSessionStatus()) {
            GIDSignIn.sharedInstance()?.signInSilently()
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

}

