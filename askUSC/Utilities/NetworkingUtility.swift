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
    var serverAddress = "http://localhost:6789/askUSC/"
    
}

// HTTP requests
extension NetworkingUtility {
    
    func registerClass(classID: String, completion: @escaping (Error?) -> Void) {
        
        let parameters: Parameters = [
            "classID": classID,
            "idToken": CoreInformation.shared.getIDToken()
        ]
        
        Alamofire.request(serverAddress + "RegisterClassServlet", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            if let error = response.error {
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
