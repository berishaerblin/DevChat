//
//  User.swift
//  DevChat
//
//  Created by Erblin Berisha on 7/30/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import UIKit

struct User {
    private var _firstName: String
    private var _uid: String
    
    
    init(uid: String, firstName: String) {
        _uid = uid
        _firstName = firstName
    }
    
    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    
}
