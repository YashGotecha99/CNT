//
//  Message.swift
//  TimeControllApp
//
//  Created by prashant on 17/04/23.
//

import Foundation

class Message: CustomStringConvertible {
//    var user: User
    var message: String
    
    init(message: String) {
//        self.user = user
        self.message = message
    }
    
    var description: String {
        return "message: \(message)]"
    }
}
