//
//  UserModel.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/22/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation

enum LoginPlatform {
    case facebook
    case twitter
    case google
}

class User {
    public var id: String
    public var name: String
    public var picURL: String = ""
    public var platform: LoginPlatform
    
    init(id: String, name: String, picURL: String, platform: LoginPlatform) {
        self.id = id
        self.name = name
        self.picURL = picURL
        self.platform = platform
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.picURL = ""
        self.platform = .facebook
    }
    
    func save() {
        
    }
}
