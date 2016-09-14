//
//  User.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 09/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var loginName: String?
    var realName: String?
    var password: String?
    var userType: String?
    
    override init() {
        
    }
    
    init(loginName: String, realName: String, password: String, userType: String) {
        self.loginName = loginName
        self.realName = realName
        self.password = password
        self.userType = userType
    }
    
}