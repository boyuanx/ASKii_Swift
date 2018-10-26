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
    
    func registerClass(classID: String, completion: @escaping (Error?) -> Void) {
        
        let parameters: Parameters = ["classID": classID]
        
        Alamofire.request("localhost:6789", parameters: parameters).responseJSON { (response) in
            if let error = response.error {
                completion(error)
            } else {
                print(response.data ?? "0")
                completion(nil)
            }
        }
    }
    
}
