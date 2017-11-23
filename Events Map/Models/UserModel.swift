//
//  UserModel.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/22/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation

enum LoginPlatform: String {
    case facebook = "FACEBOOK"
    case twitter = "TWITTER"
    case google = "GOOGLE"
    case server = "SERVER"
}

class User {
    public var id: String
    public var name: String
    public var picURL: String = ""
    
    init(id: String, name: String, picURL: String) {
        self.id = id
        self.name = name
        self.picURL = picURL    }
    
    init() {
        self.id = ""
        self.name = ""
        self.picURL = ""
    }
}
