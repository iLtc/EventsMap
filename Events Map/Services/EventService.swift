//
//  EventService.swift
//  Events Map
//
//  Created by Alan Luo on 11/3/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class EventService {
    static var instance = EventService()
    let defaults = UserDefaults.standard
    
    func getEvents(_ callback: @escaping (([Event]) -> Void)) {
        Alamofire.request(ConfigService.instance.get("EventsServerHost")).responseJSON { response in
            var events: [Event] = []
            
            if let result = response.result.value {
                let json = JSON(result)
                
                for (_, subJson): (String, JSON) in json {
                    
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
                    
                    events.append(event)
                }
            }
            
            callback(events)
        }
    }
    
/*:
 EventService.instance.getAllCategories() { categories in
     for category in categories {
        print(category)
     }
 }
 */
    func getAllCategories(_ callback: @escaping (([String]) -> Void)) {
        Alamofire.request(ConfigService.instance.get("EventsServerHost") + "/events/categories").responseJSON { response in
            var categories: [String] = []
            
            if let result = response.result.value {
                let json = JSON(result)
                
                for (_, subJson): (String, JSON) in json["categories"] {
                    categories.append(subJson.stringValue)
                }
            }
            callback(categories)
        }
    }
    
    func getCurrentCategories(_ callback: @escaping (([String]) -> Void)) {
        if let categories = defaults.array(forKey: "CurrentCategories") {
            callback(categories as! [String])
        } else {
            getAllCategories(callback)
        }
    }
    
    func setCategories(categories: [String]) {
        defaults.set(categories, forKey: "CurrentCategories")
    }
}
