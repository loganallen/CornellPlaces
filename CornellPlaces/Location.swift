//
//  Location.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import MapKit

class Location: NSObject, MKAnnotation {
    let name: String
    let category: [String]
    let subCategory: String
    let phone: String
    let hours: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, category: [String], subCategory: String, phone: String, hours: String, latitude: Double, longitude: Double) {
        self.name = name
        self.category = category
        self.subCategory = subCategory
        self.phone = phone
        self.hours = hours
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Override location description
    override var description: String {
        return "Category: \(category) | SubCat: \(subCategory) | Name: \(name)"
    }
}
