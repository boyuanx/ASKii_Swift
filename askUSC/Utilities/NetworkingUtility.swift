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
            print(response)
            if (response.result.value == "Registered") {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func registerClass(classID: String, completion: @escaping (Error?) -> Void) {
        
        let parameters: Parameters = [
            "lectureID": classID,
            "studentID": CoreInformation.shared.getUserID(),
            "requestType": "registerClass"
        ]
        
        Alamofire.request(serverAddress + "Classes", method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { (response) in
            if let error = response.error {
                print("response error!")
                completion(error)
            } else {
                print(response.data ?? "0")
                completion(nil)
            }
        }
    }
    
}

// Web socket
extension NetworkingUtility {
    
}
