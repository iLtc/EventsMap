//
//  ConfigService.swift
//  Events Map
//
//  Created by Alan Luo on 11/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation

class ConfigService {
    static var instance = ConfigService()
    
    private var configs: NSDictionary
    
    init(){
        let configPath = Bundle.main.url(forResource: "Config", withExtension: "plist")
        configs = NSDictionary(contentsOf: configPath!)!
        
        let url = NSURL(string: get("EventsServerHost"))
        let token = get("EventsServerToken")
        
        
    }
    
    func get(_ key: String) -> String {
        if let value = configs[key] {
            return value as! String
        } else {
            return ""
        }
    }
}
