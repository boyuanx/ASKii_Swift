//
//  GlobalDispatchQueue.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/21/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Foundation

class GlobalDispatchGroup {
    
    static let shared = GlobalDispatchGroup()
    private init() {}

    var queueMap = [String: DispatchGroup]()
    
    func make(named: String) {
        let dg = DispatchGroup()
        queueMap[named] = dg
    }
    
    func get(named: String) -> DispatchGroup? {
        if let dg = queueMap[named] {
            return dg
        } else {
            return nil
        }
    }
    
    func delete(named: String) -> Bool {
        if queueMap[named] != nil {
            queueMap.removeValue(forKey: named)
            return true
        } else {
            return false
        }
    }
    
}
