//
//  Core.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import GoogleSignIn

fileprivate struct Core {
    static var isSignedIn = false
    static var userID = String()
    static var idToken = String()
    static var fullName = String()
    static var firstName = String()
    static var lastName = String()
    static var email = String()
}

class CoreInformation {
    static let shared = CoreInformation()
    private init(){}
}

extension CoreInformation {

    func getSessionStatus() -> Bool {
        return Core.isSignedIn
    }
    
    func setSessionStatus(bool: Bool) {
        Core.isSignedIn = bool
    }
    
    func getUserID() -> String {
        return Core.userID
    }
    
    func setUserID(ID: String) {
        Core.userID = ID
    }
    
    func getIDToken() -> String {
        return Core.idToken
    }
    
    func setIDToken(token: String) {
        Core.idToken = token
    }
    
    func getFullName() -> String {
        return Core.fullName
    }
    
    func setFullName(name: String) {
        Core.fullName = name
    }
    
    func getName(getFirst: Bool) -> String {
        if (getFirst) {
            return Core.firstName
        } else {
            return Core.lastName
        }
    }
    
    func setName(setFirst: Bool, name: String) {
        if (setFirst) {
            Core.firstName = name
        } else {
            Core.lastName = name
        }
    }
    
    func getEmail() -> String {
        return Core.email
    }
    
    func setEmail(email: String) {
        Core.email = email
    }
    
}

struct SharedInfo {
    static let USC_redColor = UIColor(rgb: 0x991B1E)
    static let menuCellHeight = CGFloat(40)
    static let classListCellHeight = CGFloat(60)
    static var currentRootViewController = UIViewController() // Yes, I am well aware all root view controllers except for the login screen is the navigation controller.
    static var currentNavController = UINavigationController()
} 
