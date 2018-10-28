//
//  Quote.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/28/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Foundation

struct Quote {
    private(set) var quote: String!
    private(set) var author: String!
    private(set) var voters = [String]()
    
    init(quote: String, author: String, voters: [String]?) {
        self.quote = quote
        self.author = author
        if let voters = voters {
            self.voters = voters
        }
    }
    
    func getVotes() -> Int {
        return voters.count
    }
    
    mutating func vote() {
        let idToken = CoreInformation.shared.getIDToken()
        if (voters.contains(idToken)) {
            voters = voters.filter { $0 != idToken }
        } else {
            voters.append(idToken)
        }
    }
}
