//
//  UserService.swift
//  Events Map
//
//  Created by Alan Luo on 11/22/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserService {
    static var instance = UserService()
    let defaults = UserDefaults.standard
    
/*:
 UserService.instance.addUser(pid: "123", name: "Demo User", picURL: "http://example.com/...", platform:.facebook) { user in
    print(user.name, user.id, user.picURL)
 }
*/
    func addUser(pid: String, name: String, picURL: String, platform: LoginPlatform, callback: @escaping ((String, String, User?) -> Void)) {
        let parameters: Parameters = [
            "pid": pid,
            "name": name,
            "picURL": picURL,
            "platform": platform.rawValue
        ]
        
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/users/new", method: .post, parameters: parameters).responseJSON { response in
            if response.result.isFailure {
                if let error = response.result.error as? AFError {
                    callback("500", error.errorDescription!, nil)
                } else {
                    //NETWORK FAILURE
                    callback("500", "NETWORK FAILURE", nil)
                }
                return
            }
            
            if let result = response.result.value {
                let json = JSON(result)
                
                if json["code"].stringValue != "200" {
                    callback(json["code"].stringValue, json["msg"].stringValue, nil)
                    return
                }
                
                let user = User(id: json["uid"].stringValue, name: json["name"].stringValue, picURL: json["picURL"].stringValue)
                
                let userDict = [
                    "id": user.id,
                    "name": user.name,
                    "picURL": user.picURL
                ]
                self.defaults.set(userDict, forKey: "CurrentUser")
                
                callback("200", "", user)
            }
        }
    }
    
    func getDemoUser(callback: @escaping ((String, String, User?) -> Void)) {
        addUser(pid: "1234567", name: "Demo User", picURL: "https://s3.us-east-2.amazonaws.com/iltc-events/avataaars.png", platform: .server, callback: callback)
    }
    
/*:
 if let user = UserService.instance.getCurrentUser() {
     print(user.id, user.name, user.picURL)
 }
 */
    func getCurrentUser() -> User? {
        if let userDict = defaults.dictionary(forKey: "CurrentUser") {
            let user = User(id: userDict["id"] as! String, name: userDict["name"] as! String, picURL: userDict["picURL"] as! String)
            
            return user
        }else{
            return nil
        }
    }
    
    func logout() {
        defaults.removeObject(forKey: "CurrentUser")
    }
}
