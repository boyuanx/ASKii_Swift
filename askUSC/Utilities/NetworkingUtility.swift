//
//  NetworkingUtility.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/25/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//
//
//  MARK: This file and the use of Heroku backend are deprecated.
//

import Alamofire
import SwiftyJSON
import Starscream
import Valet

class NetworkingUtility {
    
    static var shared = NetworkingUtility()
    private init() {}
    var serverAddress = "http://fierce-savannah-23542.herokuapp.com/"
    var chatSocketAddress = "wss://fierce-savannah-23542.herokuapp.com/chatWS/"
    var socket: WebSocket!
    var socketAlive = false
    weak var delegate: ChatTableViewDelegate?
}

// MARK: HTTP requests
extension NetworkingUtility {
    
    func userLogin(completion: @escaping (Bool) -> Void) {
        
        let parameters: Parameters = [
            "requestType": "registerUser",
            "userID": CoreInformation.shared.getUserID(),
            "lastName": CoreInformation.shared.getName(getFirst: false),
            "firstName": CoreInformation.shared.getName(getFirst: true),
            "email": CoreInformation.shared.getEmail(),
            "userType": "student"
        ]
        
        Alamofire.request(serverAddress + "UserLogin", method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { (response) in
            if (response.result.value == "Registered" || response.result.value == "") {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func guestEnterClass(classID: String ,completion: @escaping (Class?) -> Void) {
        
        let parameters: Parameters = [
            "lectureID": classID
        ]
        
        Alamofire.request(serverAddress + "Guest", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            print(response)
            if let response = response.result.value {
                if (type(of: response) == NSNull.self) {
                    completion(nil)
                    return // Not sure why but the code does not return without this, even with the completion call
                }
                let guestClass = self.jsonToClassGuest(data: response)
                completion(guestClass)
            } else {
                completion(nil)
            }
        }
        
    }
    
    // Return values:
    // "Failed" - failed, most likely class does not exist
    // "Added" - added
    // "" - already added
    // all other - server side errors or conncetion errors
    func registerClass(classID: String, completion: @escaping (String) -> Void) {
        
        let parameters: Parameters = [
            "lectureID": classID,
            "studentID": CoreInformation.shared.getUserID(),
            "requestType": "registerClass"
        ]
        
        Alamofire.request(serverAddress + "Classes", method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { (response) in
            if let error = response.error {
                completion(error.localizedDescription)
            } else {
                completion(response.result.value ?? "Response error code: 0x6e696c")
            }
        }
    }
    
    func unregisterClass(classID: String, completion: @escaping (Bool) -> Void) {
        
        let parameters: Parameters = [
            "lectureID": classID,
            "studentID": CoreInformation.shared.getUserID(),
            "requestType": "unregisterClass"
        ]
        
        Alamofire.request(serverAddress + "Classes", method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                completion(false)
            } else {
                if (response.result.value == "Deleted") {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    
    func getClasses(completion: @escaping ([Class]) -> Void) {
        
        let parameters: Parameters = [
            "requestType": "getClasses",
            "studentID": CoreInformation.shared.getUserID()
        ]
        
        Alamofire.request(serverAddress + "Classes", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            if let data = response.result.value {
                let classArray = self.jsonToClass(data: data)
                completion(classArray)
            }
        }
    }
    
    func checkIn(lectureID: String, completion: @escaping (String) -> Void) {
        
        let parameters: Parameters = [
            "studentID": CoreInformation.shared.getUserID(),
            "lectureID": lectureID,
            "requestType": "checkIn"
        ]
        
        Alamofire.request(serverAddress + "Attendance", method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { (response) in
            if let error = response.error {
                completion(error.localizedDescription)
            }
            completion(response.result.value ?? "Response error code: 0x6e696c")
        }
    }
    
    func getAttendanceHistory(lectureID: String, completion: @escaping ([Attendance]) -> Void) {
        
        let parameters: Parameters = [
            "studentID": CoreInformation.shared.getUserID(),
            "lectureID": lectureID,
            "requestType": "getStudentHistory"
        ]
        
        Alamofire.request(serverAddress + "Attendance", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            if let data = response.result.value {
                let attendanceArray = self.jsonToAttendance(data: data)
                completion(attendanceArray)
            }
        }
    }
    
}

// MARK: Web socket
extension NetworkingUtility: WebSocketDelegate {
    
    func connectToChatSocket(classID: String) {
        socket = WebSocket(url: URL(string: chatSocketAddress + "/" + CoreInformation.shared.getUserID() + "/" + classID)!)
        socket.delegate = self
        socket.connect()
    }
    
    func writeMessageToChatSocket(message: Message) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let json = try! encoder.encode(message)
        print(String(data: json, encoding: .utf8)!)
        socket.write(string: String(data: json, encoding: .utf8)!)
    }
    
    func disconnectFromChatSocket() {
        socketAlive = false
        socket.disconnect()
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("ChatSocket is connected.")
        socketAlive = true
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if (socketAlive) {
            print("ChatSocket connection dropped. Attempting to reconnect.")
            socket.connect()
        } else {
            print("ChatSocket is disconnected.")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let message = jsonToMessage(data: text)
        delegate?.receiveChatMessage(message: message)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data)")
    }
    
}

// MARK: JSON parsing
extension NetworkingUtility {
    
    func jsonToClass(data: Any) -> [Class] {
        let json = JSON(data)
        let array = json.arrayValue
        var resultArray = [Class]()
        for element in array {
            let classID = element["id"].stringValue
            let department = element["department"].stringValue
            let classNumber = element["classNumber"].stringValue
            let classDescription = element["classDescription"].stringValue
            let classInstructor = element["instructor"].stringValue
            print(classID + classDescription)
            let start = hhmmssToTimeToday(data: element["startTime"].stringValue)
            let end = hhmmssToTimeToday(data: element["endTime"].stringValue)
            let meetingDaysOfWeek = element["meetingDaysOfWeek"].stringValue
            let classLat = element["latitude"].doubleValue
            let classLong = element["longitude"].doubleValue
            
            let c = Class(classID: classID, className: department+classNumber, classDescription: classDescription, classInstructor: classInstructor, start: start, end: end, meetingDaysOfWeek: meetingDaysOfWeek, classLat: classLat, classLong: classLong)
            resultArray.append(c)
        }
        return resultArray
    }
    
    func jsonToClassGuest(data: Any) -> Class {
        let json = JSON(data)
        let map = json.dictionaryValue
        let classID = (map["id"]?.stringValue)!
        let department = (map["department"]?.stringValue)!
        let classNumber = (map["classNumber"]?.stringValue)!
        let classDescription = (map["classDescription"]?.stringValue)!
        let classInstructor = (map["instructor"]?.stringValue)!
        let start = hhmmssToTimeToday(data: (map["startTime"]?.stringValue)!)
        let end = hhmmssToTimeToday(data: (map["endTime"]?.stringValue)!)
        let meetingDaysOfWeek = (map["meetingDaysOfWeek"]?.stringValue)!
        let classLat = (map["latitude"]?.doubleValue)!
        let classLong = (map["longitude"]?.doubleValue)!
        
        let c = Class(classID: classID, className: department+classNumber, classDescription: classDescription, classInstructor: classInstructor, start: start, end: end, meetingDaysOfWeek: meetingDaysOfWeek, classLat: classLat, classLong: classLong)
        
        return c
    }
    
    func jsonToAttendance(data: Any) -> [Attendance] {
        let json = JSON(data)
        let array = json.arrayValue
        var resultArray = [Attendance]()
        for element in array {
            let date = element["date"].stringValue
            let attended = element["attended"].stringValue
            
            let a = Attendance(date: date, attended: attended)
            resultArray.append(a)
        }
        return resultArray
    }
    
    func jsonToMessage(data: String) -> Message {
        let json = JSON(parseJSON: data)
        let type = json["type"].stringValue
        let sender = json["sender"].stringValue
        let messageID = json["messageID"].stringValue
        let classID = json["classID"].stringValue
        if (type == MessageType.NewMessage.rawValue) {
            let data = json["data"].stringValue
            let voters = json["voters"].arrayObject as! [String]
            let TIMESTAMP = json["TIMESTAMP"].stringValue
            return Message(type: type, data: data, sender: sender, classID: classID, voters: voters, messageID: messageID, TIMESTAMP: TIMESTAMP)
        } else if (type == MessageType.Vote.rawValue) {
            return Message(sender: sender, messageID: messageID, classID: classID)
        } else {
            return Message()
        }
    }
    
    func parseMeetingDaysOfWeek(data: String) -> [String] {
        var result = [String]()
        for char in data {
            result.append(SharedInfo.daysOfWeek[String(char)]!)
        }
        return result
    }
    
    func isClassInSessionToday(meetingTimes: [String]) -> Bool {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale.current
        formatter.timeZone = NSTimeZone.local
        let todayTime = formatter.string(from: today)
        return meetingTimes.contains(todayTime)
    }
    
    func hhmmssToTimeToday(data: String) -> Date {
        let today = Date()
        let formatter0 = DateFormatter()
        formatter0.dateFormat = "yyyy-MM-dd"
        formatter0.locale = Locale.current
        formatter0.timeZone = NSTimeZone.local
        let todayTime = formatter0.string(from: today)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        formatter.timeZone = NSTimeZone.local
        print(todayTime + " " + data)
        return formatter.date(from: todayTime + " " + data)!
    }
    
}

// MARK: Helper functions
extension NetworkingUtility {
    
    // Return values:
    // "Not in session."
    // "Already checked in."
    // "Location failed."
    // "Success"
    // "Failed" - Server-side failure
    func tryCheckIn(thisClass: Class, completion: @escaping (String) -> Void) {
        
        if (!thisClass.isCurrentlyInSession()) {
            completion("Not in session.")
            return
        }
        
        let myValet = Valet.valet(with: Identifier(nonEmpty: "checkIn")!, accessibility: .whenUnlocked)
        let lastCheckedInClass = myValet.string(forKey: "lastCheckedInClass") ?? "0"
        if (lastCheckedInClass == thisClass.classID) {
            completion("Already checked in.")
        } else {
            thisClass.isWithinVicinity { (bool) in
                if (!bool) {
                    completion("Location failed.")
                } else {
                    self.checkIn(lectureID: thisClass.classID) { (response) in
                        if (response == "Success") {
                            myValet.set(string: thisClass.classID, forKey: "lastCheckedInClass")
                        }
                        completion(response)
                    }
                }
            }
        }
    }
    
}
