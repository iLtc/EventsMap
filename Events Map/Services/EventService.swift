//
//  EventService.swift
//  Events Map
//
//  Created by Alan Luo on 11/3/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventService {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static var instance = EventService()
    let defaults = UserDefaults.standard
    
    func formatEvent(_ subJson: JSON) -> Event {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = dateFormatter.date(from: subJson["first_date"].stringValue)
        let endDate = dateFormatter.date(from: subJson["last_date"].stringValue)
        
        let event = Event(
            id: subJson["eid"].stringValue,
            title: subJson["title"].stringValue,
            url: subJson["url"].stringValue,
            date: date! as NSDate,
            endDate: endDate! as NSDate,
            isAllDay: subJson["all_day"] == "true",
            location: subJson["location"].stringValue,
            description: subJson["description"].stringValue
        )
        
        for (_, photo): (String, JSON) in subJson["photos"] {
            event.photos.append(photo.stringValue)
        }
        
        event.geo["latitude"] = subJson["geo"]["latitude"].stringValue
        event.geo["longitude"] = subJson["geo"]["longitude"].stringValue
        
        for category in subJson["categories"].arrayValue {
            event.categories.append(category.stringValue)
        }
        
        if subJson["liked"].stringValue == "true" {
            event.liked = true
        }
        
        if subJson["owned"].stringValue == "true" {
            event.owned = true
        }
        
        if subJson["likes"].stringValue != "null" {
            if let likes = Int(subJson["likes"].stringValue) {
                event.likes = likes
            }
        }
        
        if subJson["views"].stringValue != "null" {
            if let views = Int(subJson["views"].stringValue) {
                event.views = views
            }
        }
        
        return event
    }
    
    func getEvents(_ callback: @escaping ((String, String, [Event]) -> Void)) {
        var parameters: [String: String] = [:]
        if let user = UserService.instance.getCurrentUser() {
            parameters["uid"] = user.id
        }
        if let sources = defaults.array(forKey: "CurrentSources") {
            parameters["sources"] = (sources as! [String]).joined(separator: ",")
        }
        if let categories = defaults.array(forKey: "CurrentCategories") {
            parameters["categories"] = (categories as! [String]).joined(separator: ",")
        }
        if let sort = defaults.string(forKey: "CurrentSort") {
            parameters["sort"] = sort
        }
        
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events", parameters: parameters).responseJSON { response in
            
            if response.result.isFailure {
                if let error = response.result.error as? AFError {
                    callback("500", error.errorDescription!, [])
                } else {
                    //NETWORK FAILURE
                    callback("500", "NETWORK FAILURE", [])
                }
                return
            }
            
            if let result = response.result.value {
                let json = JSON(result)
                
                if json["code"].stringValue != "200" {
                    callback(json["code"].stringValue, json["msg"].stringValue, [])
                    return
                }
                
                var events: [Event] = []
                
                for (_, subJson): (String, JSON) in json["events"] {
                    let event = self.formatEvent(subJson)
                    
                    events.append(event)
                }
                callback("200", "", events)
            }
        }
    }
    
    func getAllUserEvents(_ callback: @escaping ((String, String, [Event]) -> Void)) {
        var parameters: [String: String] = [:]
        if let user = UserService.instance.getCurrentUser() {
            parameters["uid"] = user.id
        }
        
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events/user", parameters: parameters).responseJSON { response in
            
            if response.result.isFailure {
                if let error = response.result.error as? AFError {
                    callback("500", error.errorDescription!, [])
                } else {
                    //NETWORK FAILURE
                    callback("500", "NETWORK FAILURE", [])
                }
                return
            }
            
            if let result = response.result.value {
                let json = JSON(result)
                
                if json["code"].stringValue != "200" {
                    callback(json["code"].stringValue, json["msg"].stringValue, [])
                    return
                }
                
                var events: [Event] = []
                
                for (_, subJson): (String, JSON) in json["events"] {
                    let event = self.formatEvent(subJson)
                    
                    events.append(event)
                }
                
                callback("200", "", events)
            }
        }
    }
    
/*:
 EventService.instance.getAllCategories() { categories in
     for category in categories {
        print(category)
     }
 }
 */
    func getAllCategories(_ callback: @escaping ((String, String, [String]) -> Void)) {
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events/categories").responseJSON { response in
            if response.result.isFailure {
                if let error = response.result.error as? AFError {
                    callback("500", error.errorDescription!, [])
                } else {
                    //NETWORK FAILURE
                    callback("500", "NETWORK FAILURE", [])
                }
                return
            }
            
            if let result = response.result.value {
                let json = JSON(result)
                
                if json["code"].stringValue != "200" {
                    callback(json["code"].stringValue, json["msg"].stringValue, [])
                    return
                }
                
                var categories: [String] = []
                
                for (_, subJson): (String, JSON) in json["categories"] {
                    categories.append(subJson.stringValue)
                }
                
                callback("200", "", categories)
            }
        }
    }
    
    func getCurrentCategories(_ callback: @escaping ((String, String, [String]) -> Void)) {
        if let categories = defaults.array(forKey: "CurrentCategories") {
            callback("200", "", categories as! [String])
        } else {
            getAllCategories(callback)
        }
    }
    
    func setCategories(categories: [String]) {
        defaults.set(categories, forKey: "CurrentCategories")
    }
    
    func getAllSources(_ callback: @escaping (([String]) -> Void)) {
        callback(["University of Iowa", "Iowa City", "Events Server"])
    }
    
    func getCurrentSources(_ callback: @escaping (([String]) -> Void)) {
        if let sources = defaults.array(forKey: "CurrentSources") {
            callback(sources as! [String])
        } else {
            getAllSources(callback)
        }
    }
    
    func setSources(sources: [String]) {
        defaults.set(sources, forKey: "CurrentSources")
    }
    
    func getCurrentSort(_ callback: @escaping ((String) -> Void)) {
        if let sort = defaults.string(forKey: "CurrentSort") {
            callback(sort)
        } else {
            callback("Start Time")
        }
    }
    
    func setSort(sort: String) {
        defaults.set(sort, forKey: "CurrentSort")
    }
    
    func like(_ event: Event, _ callback: @escaping ((String, String) -> Void)) {
        if let user = UserService.instance.getCurrentUser() {
            let parameters = ["uid": user.id]
            Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events/" + event.id + "/like", method: .post, parameters: parameters).responseJSON { response in
                if response.result.isFailure {
                    if let error = response.result.error as? AFError {
                        callback("500", error.errorDescription!)
                    } else {
                        //NETWORK FAILURE
                        callback("500", "NETWORK FAILURE")
                    }
                    return
                }
                
                if let result = response.result.value {
                    let json = JSON(result)
                    
                    if json["code"].stringValue != "200" {
                        callback(json["code"].stringValue, json["msg"].stringValue)
                        return
                    }
                    
                    callback("200", "")
                    
                    self.appDelegate?.scheduleNotification(event)
                }
            }
        }else{
            // TODO: Pop up login
            callback("401", "You haven't logged in.")
        }
    }
    
    func unlike(_ event: Event, _ callback: @escaping ((String, String) -> Void)) {
        if let user = UserService.instance.getCurrentUser() {
            let parameters = ["uid": user.id]
            Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events/" + event.id + "/unlike", method: .post, parameters: parameters).responseJSON { response in
                if response.result.isFailure {
                    if let error = response.result.error as? AFError {
                        callback("500", error.errorDescription!)
                    } else {
                        //NETWORK FAILURE
                        callback("500", "NETWORK FAILURE")
                    }
                    return
                }
                
                if let result = response.result.value {
                    let json = JSON(result)
                    
                    if json["code"].stringValue != "200" {
                        callback(json["code"].stringValue, json["msg"].stringValue)
                        return
                    }
                    
                    callback("200", "")
                }
            }
        } else {
            // TODO: Pop up login
            callback("401", "You haven't logged in.")
        }
    }
    
    func uploadImage(_ image: UIImage, _ callback: @escaping ((String, String, String) -> Void) ) {
        var urlRequest = URLRequest(url: URL(string: ConfigService.instance.get("EventsServerHost") + "/events/image")!)
        urlRequest.httpMethod = "POST"
        
        let imgData = UIImageJPEGRepresentation(image, 0.5)!
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            MultipartFormData.append(imgData, withName: "fileset", fileName: "name", mimeType: "image/jpg")
        }, with: urlRequest, encodingCompletion: { encodingResult in
            
            switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let result = response.result.value {
                            let json = JSON(result)
                            
                            callback(json["code"].stringValue, json["msg"].stringValue, json["url"].stringValue)
                        }
                    }
                case .failure(let error):
                    print(error)
                callback("500", error.localizedDescription, "")
            }
        })
    }
    
    func addEvent(_ event: Event, _ callback: @escaping ((String, String, Event?) -> Void) ) {
        var parameters = [
            "title": event.title,
            "date": event.date,
            "endDate": event.endDate,
            "location": event.location,
            "description": event.description,
            "photo": event.photos[0],
            "la": event.geo["latitude"]!,
            "lo": event.geo["longitude"]!
            ] as [String : Any]
        
        if let user = UserService.instance.getCurrentUser() {
            parameters["uid"] = user.id
        }
        
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events", method: .post, parameters: parameters).responseJSON { response in
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
                
                event.id = json["id"].stringValue
                event.url = ConfigService.instance.get("EventsServerHost") + "/events/" + json["id"].stringValue
                
                callback("200", "", event)
            }
        }
    }
    
    func countViews(_ event: Event) {
        let parameters = ["eid": event.id]
        
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events/views", method: .post, parameters: parameters)
    }
    
    func delete(_ event: Event, _ callback: @escaping ((String, String) -> Void)) {
        var parameters: [String: Any] = [:]
        if let user = UserService.instance.getCurrentUser() {
            parameters["uid"] = user.id
        }else{
            callback("403", "User Not Login")
        }
        
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events/" + event.id, method: .delete, parameters: parameters).responseJSON { response in
            
            if response.result.isFailure {
                if let error = response.result.error as? AFError {
                    callback("500", error.errorDescription!)
                } else {
                    //NETWORK FAILURE
                    callback("500", "NETWORK FAILURE")
                }
                return
            }
            
            if let result = response.result.value {
                let json = JSON(result)
                callback(json["code"].stringValue, json["msg"].stringValue)
            }
        }
    }
}
