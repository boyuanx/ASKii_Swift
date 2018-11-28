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
    }
    
    func appendNewMessage(message: Message) throws {
        if (CoreInformation.shared.getName(getFirst: true) != "Guest") {
            try appendMessageToStorage(message: message)
        }
        if (!DiskManager.classMessageMap.keys.contains(message.classID)) {
            DiskManager.classMessageMap[message.classID] = [Message]()
        }
        DiskManager.classMessageMap[message.classID]?.append(message)
    }
    
    func saveMessageArray(array: [Message]) throws {
        if doesMessageExist() != nil {
            try Disk.append(array, to: "messages_\(CoreInformation.shared.getUserID()).json", in: .documents)
        } else {
            try Disk.save(array, to: .documents, as: "messages_\(CoreInformation.shared.getUserID()).json")
        }
    }
    
    func overwriteMessageArray(array: [Message]?) throws {
        if let array = array {
            try Disk.save(array, to: .documents, as: "messages_\(CoreInformation.shared.getUserID()).json")
        } else {
            let messagesNestedArray = Array(DiskManager.classMessageMap.values)
            var messagesArray = [Message]()
            for element in messagesNestedArray {
                messagesArray += element
            }
            try Disk.save(messagesArray, to: .documents, as: "messages_\(CoreInformation.shared.getUserID()).json")
        }
    }
    
    private func appendMessageToStorage(message: Message) throws {
        if doesMessageExist() != nil {
            try Disk.append(message, to: "messages_\(CoreInformation.shared.getUserID()).json", in: .documents)
        } else {
            var messageArray = [Message]()
            messageArray.append(message)
            try Disk.save(messageArray, to: .documents, as: "messages_\(CoreInformation.shared.getUserID()).json")
        }
    }
    
    func deleteAllMessages() {
        try? Disk.remove("messages_\(CoreInformation.shared.getUserID()).json", from: .documents)
        DiskManager.classMessageMap = [String: [Message]]()
    }
    
    private func doesMessageExist() -> [Message]? {
        do {
            return try Disk.retrieve("messages_\(CoreInformation.shared.getUserID()).json", from: .documents, as: [Message].self)
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
}

extension DiskManager {
    
    func getDateMessageGroupsForClass(classID: String) -> [DateMessageGroup]? {
        // Separate messages into groups of different dates
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
            // Then, sort the messages in individual groups by upvotes
            for groupIndex in result.indices {
                result[groupIndex].messages.sort(by: { $0.voters.count > $1.voters.count })
            }
            return result
        } else {
            return nil
        }
    }
    
}

// MARK: Image storage
extension DiskManager {
    
    func fetchImageFromDisk(name: String) -> UIImage? {
        return try? Disk.retrieve(name, from: .documents, as: UIImage.self)
    }
    
    func saveImageToDisk(name: String, image: UIImage) {
        try? Disk.save(image, to: .documents, as: name)
    }
    
}
