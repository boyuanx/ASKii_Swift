//
//  Attendance.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/18/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Foundation

struct Attendance: Codable {
    private(set) var date: String!
    private(set) var attended: String!
    
    init(date: String, attended: String) {
        let tempDate = Formatter.YYYYMMDD_Format.date(from: date)!
        self.date = Formatter.Date.EEEEMMdyyyy.string(from: tempDate)
        self.attended = attended
    }
}
