//
//  User.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 09/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import Foundation

class User: NSObject {
    // properties
    var name: String?
    var password: String?
    
    override init() {
        
    }
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    override var description: String {
        return "Name: \(name), Password: \(password)"
    }
}