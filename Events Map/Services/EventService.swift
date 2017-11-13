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
    
    private var events: [ Event ] = []
    private(set) var isReady = false
    
    func sync(_ callback: @escaping (() -> Void)) {
        Alamofire.request(ConfigService.instance.get("EventsServerHost")).responseJSON { response in
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
                    
                    self.events.append(event)
                }
            }
            
            self.isReady = true
            callback()
        }
    }
    
    func getEvents() -> [Event] {
        if isReady {
            return self.events
        } else {
            return []
        }
    }
}
