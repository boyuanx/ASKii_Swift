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

    private static var classMessageMap = [String: [Message]]()
}

extension DiskManager {
    
    func readMessagesFromDisk() {
        if let messagesArray = doesMessageExist() {
            for message in messagesArray {
                if DiskManager.classMessageMap.keys.contains(message.classID) {
                    DiskManager.classMessageMap[message.classID]?.append(message)
                } else {
                    DiskManager.classMessageMap[message.classID] = [Message]()
                    DiskManager.classMessageMap[message.classID]?.append(message)
                }
            }
        }
        print(DiskManager.classMessageMap)
    }
    
    func appendNewMessage(message: Message) throws {
        try appendMessageToStorage(message: message)
        if (!DiskManager.classMessageMap.keys.contains(message.classID)) {
            DiskManager.classMessageMap[message.classID] = [Message]()
        }
        DiskManager.classMessageMap[message.classID]?.append(message)
        print(DiskManager.classMessageMap)
    }
    
    func saveMessageArray(array: [Message]) throws {
        if doesMessageExist() != nil {
            try Disk.append(array, to: "messages_\(CoreInformation.shared.getUserID()).json", in: .documents)
        } else {
            try Disk.save(array, to: .documents, as: "messages_\(CoreInformation.shared.getUserID()).json")
        }
    }
    
    private func appendMessageToStorage(message: Message) throws {
        if doesMessageExist() != nil {
            try Disk.append(message, to: "messages_\(CoreInformation.shared.getUserID()).json", in: .documents)
        } else {
            try Disk.save(message, to: .documents, as: "messages_\(CoreInformation.shared.getUserID()).json")
        }
    }
    
    func deleteAllMessages() {
        try? Disk.remove("messages_\(CoreInformation.shared.getUserID()).json", from: .documents)
    }
    
    private func doesMessageExist() -> [Message]? {
        do {
            return try Disk.retrieve("messages_\(CoreInformation.shared.getUserID()).json", from: .documents, as: [Message].self)
        } catch {
            return nil
        }
    }
    
}

extension DiskManager {
    
    func getDateMessageGroupsForClass(classID: String) -> [DateMessageGroup]? {
        print(DiskManager.classMessageMap)
        if let messages = DiskManager.classMessageMap[classID] {
            var result = [DateMessageGroup]()
            let sortedMessages = messages.sorted()
            var prevMessageDate = Formatter.Date.iso8601.date(from: sortedMessages[0].TIMESTAMP)!
            var currentDateMessageGroup = DateMessageGroup(date: prevMessageDate)
            for message in sortedMessages {
                let currentMessageDate = Formatter.Date.iso8601.date(from: message.TIMESTAMP)!
                if (prevMessageDate.compareCloseTo(currentMessageDate, precision: 5.hours.timeInterval)) {
                    // Still the same lecture
                    currentDateMessageGroup.messages.append(message)
                } else {
                    // Different lecture
                    result.append(currentDateMessageGroup)
                    currentDateMessageGroup = DateMessageGroup(date: currentMessageDate)
                    currentDateMessageGroup.messages.append(message)
                }
                prevMessageDate = currentMessageDate
            }
            if (result.count == 0) {
                result.append(currentDateMessageGroup)
            }
            return result
        } else {
            return nil
        }
    }
    
}
