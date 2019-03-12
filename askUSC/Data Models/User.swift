//
//  User.swift
//  askUSC
//
//  Created by Boyuan Xu on 1/12/19.
//  Copyright © 2019 Boyuan Xu. All rights reserved.
//

import Foundation

struct User: Codable {
    var userID = String()
    var email = String()
    var firstName = String()
    var lastName = String()
    var profileImgURL = String()
    // Array of strings of office hour IDs.
    var queues = [String]()
    // Array of strings of class IDs.
    var classes = [String]()

    init(userID: String, email: String, firstName: String, lastName: String) {
        self.userID = userID
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
