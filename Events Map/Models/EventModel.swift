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
    public var date: String
    public var location: String
    public var description: String
    public var photos: [String] = []
    public var geo: [String: String] = [:]
    public var categories: [String] = []
    
    init(id: String, title: String, url: String, date: String, location: String, description: String){
        self.id = id
        self.title = title
        self.url = url
        self.date = date
        self.location = location
        self.description = description
    }
    
    func debug() -> String {
        return "id: \(self.id), title: \(self.title.trunc(7)), url: \(self.url.trunc(7)), date: \(self.date.trunc(7)), location: \(self.location.trunc(7)), description: \(self.description.trunc(21)), photos: \(self.photos.joined(separator: ", ").trunc(7)), geo: \(self.geo), categories: \(self.categories.joined(separator: ", ").trunc(21))"
    }
}
