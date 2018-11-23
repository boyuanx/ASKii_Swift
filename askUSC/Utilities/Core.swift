//
//  Core.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftDate

fileprivate struct Core {
    static var isSignedIn = false
    static var userID = String()
    static var idToken = String()
    static var fullName = String()
    static var firstName = String()
    static var lastName = String()
    static var email = String()
    static var profile = Profile()
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
    
    func getProfile() -> Profile {
        return Core.profile
    }
    
    func setProfile(profile: Profile) {
        Core.profile = profile
    }
}

struct SharedInfo {
    static let USC_redColor = UIColor(rgb: 0x991B1E)
    static let menuCellHeight = CGFloat(40)
    static let classListCellHeight = CGFloat(80)
    static var currentRootViewController = UIViewController() // Yes, I am well aware all root view controllers except for the login screen is the navigation controller.
    static var currentNavController = UINavigationController()
    static let daysOfWeek = [
        "2": "Mon",
        "3": "Tue",
        "4": "Wed",
        "5": "Thu",
        "6": "Fri",
        "7": "Sat",
        "1": "Sun"
    ]
    
    // MARK: Classes
    // Class list that's fetched when:
    // 1. The user first logs in
    // 2. The user (un)enrolls in a class
    static var classList = [Class]()
    
    static func fetchClassListFromServer(completion: @escaping () -> Void) {
        NetworkingUtility.shared.getClasses { (classes) in
            SharedInfo.classList = classes
            completion()
        }
    }
    
    static func getNextClass() -> Class {
        var temp = SharedInfo.classList
        var result = Class()
        temp.sort()
        for element in temp {
            if (element.start > Date()) {
                result = element
                break
            }
        }
        return result
    }
    
}
