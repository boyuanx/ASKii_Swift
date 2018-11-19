//
//  NetworkingUtility.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/25/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
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
    
}

// MARK: HTTP requests
extension NetworkingUtility {
    
    func userLogin(completion: @escaping (Bool) -> Void) {
        
        let parameters: Parameters = [
            "requestType": "registerUser",
            "idToken": CoreInformation.shared.getIDToken(),
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
    
    func getClasses(completion: @escaping ([Class]) -> Void) {
        
        let parameters: Parameters = [
            "requestType": "getClasses",
            "studentID": CoreInformation.shared.getUserID()
        ]
        
        Alamofire.request(serverAddress + "Classes", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            print(response)
            
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
    
}

// MARK: Web socket
extension NetworkingUtility: WebSocketDelegate {
    
    func connectToChatSocket(classID: String) {
        socket = WebSocket(url: URL(string: chatSocketAddress + "query?userID=" + CoreInformation.shared.getUserID() + "&classID=" + classID)!)
        print(chatSocketAddress + "query?userID=" + CoreInformation.shared.getUserID() + "&classID=" + classID)
        socket.delegate = self
        socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("ChatSocket is connected.")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("ChatSocket is disconnected.")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: " + text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
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
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        formatter.locale = Locale.current
        formatter.timeZone = NSTimeZone.local
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
        }
        
        let myValet = Valet.valet(with: Identifier(nonEmpty: "checkIn")!, accessibility: .whenUnlocked)
        let lastCheckedInClass = myValet.string(forKey: "lastCheckedInClass") ?? "0"
        if (lastCheckedInClass == thisClass.classID) {
            completion("Already checked in.")
        } else {
            thisClass.isWithinVicinity { [weak self] (bool) in
                if (!bool) {
                    completion("Location failed.")
                } else {
                    self?.checkIn(lectureID: thisClass.classID) { (response) in
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
