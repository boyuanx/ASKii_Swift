//
//  NetworkingUtility.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/25/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Alamofire

class NetworkingUtility {
    
    static var shared = NetworkingUtility()
    private init() {}
    var serverAddress = "http://fierce-savannah-23542.herokuapp.com/"
    //var serverAddress = "http://localhost:8080/FinalProject"

    
}

// HTTP requests
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
    
}

// Web socket
extension NetworkingUtility {
    
}
