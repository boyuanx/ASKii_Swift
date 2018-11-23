//
//  GlobalDataPersistence.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/22/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Foundation
import Disk

class DiskManager {
    static let shared = DiskManager()
    private init() {}

    static var classMessageMap = [String: [Message]]()
}

extension DiskManager {
    
    func appendNewMessage(message: Message) throws {
        try appendMessageToStorage(message: message)
        DiskManager.classMessageMap[message.classID]?.append(message)
    }
    
    func saveMessageArray(array: [Message]) throws {
        let fileExists = doesMessageExist()
        if (fileExists) {
            try Disk.append(array, to: "messages.json", in: .documents)
        } else {
            try Disk.save(array, to: .documents, as: "messages.json")
        }
    }
    
    private func appendMessageToStorage(message: Message) throws {
        let fileExists = doesMessageExist()
        if (fileExists) {
            try Disk.append(message, to: "messages.json", in: .documents)
        } else {
            try Disk.save(message, to: .documents, as: "messages.json")
        }
    }
    
    func deleteAllMessages() {
        try? Disk.remove("messages.json", from: .documents)
    }
    
    private func doesMessageExist() -> Bool {
        do {
            _ = try Disk.retrieve("messages.json", from: .documents, as: Message.self)
            return true
        } catch {
            return false
        }
    }
    
}
