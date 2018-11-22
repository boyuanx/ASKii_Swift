//
//  Message.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/28/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Foundation
import SwiftDate

enum MessageType: String {
    case text
    case image
}

struct DateMessageGroup: Codable {
    private(set) var date: String!
    var messages = [Message]()
    
    init(date: Date? = Date()) {
        if let date = date {
            self.date = Formatter.YYYYMMDD_Format.string(from: date)
        } else {
            self.date = Formatter.YYYYMMDD_Format.string(from: Date())
        }
    }
    
    init(date: String) {
        self.date = date
    }
    
}

struct Message: Codable {
    private(set) var type: String!
    private(set) var data: String!
    private(set) var sender: String!
    private(set) var classID: String!
    private(set) var voters: [String]!
    private(set) var messageID: String!
    
    init(type: String, data: Any, sender: String, classID: String, voters: [String]?, messageID: String?) {
        // Type
        self.type = type
        // Data
        if (type == MessageType.text.rawValue) {
            self.data = data as? String ?? "My name is \(CoreInformation.shared.getName(getFirst: true)) and I am trying to mess with this app!"
        } else {
            self.data = "Unsupported data type."
        }
        // Sender
        self.sender = sender
        // classID
        self.classID = classID
        // Voters
        if let voters = voters {
            self.voters = voters
        } else {
            self.voters = [String]()
        }
        // MessageID
        if let messageID = messageID {
            self.messageID = messageID
        } else {
            self.messageID = UUID().uuidString
        }
    }
    
    func getVotes() -> Int {
        return voters.count
    }
    
    mutating func vote() {
        let idToken = CoreInformation.shared.getIDToken()
        if (voters.contains(idToken)) {
            voters.append(idToken)
        } else {
            voters = voters.filter { $0 != idToken }
        }
    }
}
