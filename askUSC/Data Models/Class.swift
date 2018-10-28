//
//  Class.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/28/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftLocation
import CoreLocation
import SCLAlertView

struct Class: Equatable, Comparable {
    
    static func < (lhs: Class, rhs: Class) -> Bool {
        if (lhs.start != rhs.start) {
            return lhs.start < rhs.start
        } else {
            return lhs.end < rhs.end
        }
    }
    
    static func == (lhs: Class, rhs: Class) -> Bool {
        return lhs.classID == rhs.classID
    }
    
    private(set) var classID: String!
    private(set) var className: String!
    private(set) var classDescription: String!
    private(set) var classInstructor: String!
    private(set) var start: Date!
    private(set) var end: Date!
    private(set) var classLocation: CLLocation!
    
    func isCurrentlyInSession() -> Bool {
        let currentTime = Date()
        if (currentTime > start && currentTime < end) {
            return true
        } else {
            return false
        }
    }
    
    func isWithinVicinity(completion: @escaping (Bool) -> Void) {
        let dg = DispatchGroup()
        dg.enter()
        var isWithinVicinity = false
        Locator.currentPosition(accuracy: .room, onSuccess: { (location) -> (Void) in
            if (location.distance(from: self.classLocation) < 50) {
                isWithinVicinity = true
                dg.leave()
            }
        }) { (error, location) -> (Void) in
            let alert = SCLAlertView()
            alert.showError("Location Error", subTitle: error.localizedDescription)
            dg.leave()
        }
        dg.notify(queue: .main) {
            completion(isWithinVicinity)
        }
    }
}
