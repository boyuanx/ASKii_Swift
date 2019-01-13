//
//  Profile.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/28/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//
//  Currently NOT in use!

import Foundation

struct Profile: Codable {
    private(set) var type: String!
    private(set) var classes = [Class]()
    var currentClass: Class? {
        get {
            var currentClass: Class?
            classes.forEach { (c) in
                if (c.isCurrentlyInSession()) {
                    currentClass = c
                }
            }
            return currentClass
        }
    }
    private(set) var quote: Quote?
    var profilePicURL: String?
    
    init() {}
    
    init(type: String, classes: [Class]?, quote: Quote?, profilePicURL: String?) {
        // Type
        self.type = type
        // Classes if exists
        if let classes = classes {
            self.classes = classes
        }
        // Quote if exists
        if let quote = quote {
            self.quote = quote
        }
        // Profile Pic if exists
        if let url = profilePicURL {
            self.profilePicURL = url
        }
    }
    
    mutating func addClass(_class: Class) -> Bool {
        if (classes.contains(_class)) {
            return false
        } else {
            classes.append(_class)
            return true
        }
    }
    
    mutating func removeClass(_class: Class) -> Bool {
        if (classes.contains(_class)) {
            classes = classes.filter { $0 != _class }
            return true
        } else {
            return false
        }
    }
}
