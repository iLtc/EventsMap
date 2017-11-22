//
//  UserModel.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/22/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation

class Profile {
    public var id: String
    public var name: String
    public var picURL: String = ""
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {
        self.id = ""
        self.name = ""
    }
}
