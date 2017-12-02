//
//  EventModel.swift
//  Events Map
//
//  Created by Alan Luo on 11/3/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation

class Event {
    public var id: String
    public var title: String
    public var url: String
    public var date: NSDate
    public var endDate: NSDate
    public var isAllDay: Bool
    public var location: String
    public var description: String
    public var liked = false
    public var owned = false
    public var photos: [String] = []
    public var geo: [String: String] = [
        "latitude": "",
        "longitude": ""
    ]
    public var categories: [String] = []
    
    init(id: String, title: String, url: String, date: NSDate, endDate: NSDate, isAllDay: Bool, location: String, description: String){
        self.id = id
        self.title = title
        self.url = url
        self.date = date
        self.endDate = endDate
        self.isAllDay = isAllDay
        self.location = location
        self.description = description
    }
    
    init() {
        self.id = ""
        self.title = ""
        self.url = ""
        self.date = NSDate()
        self.endDate = NSDate()
        self.isAllDay = false
        self.location = ""
        self.description = ""
    }
    
    func like() -> Bool {
        return EventService.instance.like(self)
    }
    
    func unlike() {
        EventService.instance.unlike(self)
    }
    
    func save(_ callback: @escaping ((Event) -> Void) ) {
        EventService.instance.addEvent(self, callback)
    }
    
    func debug() -> String {
        return "id: \(self.id), title: \(self.title.trunc(7)), url: \(self.url.trunc(7)), date: \(self.date), location: \(self.location.trunc(7)), description: \(self.description.trunc(21)), photos: \(self.photos.joined(separator: ", ").trunc(7)), geo: \(self.geo), categories: \(self.categories.joined(separator: ", ").trunc(21))"
    }
}
