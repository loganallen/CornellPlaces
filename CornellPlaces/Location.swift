//
//  Location.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import MapKit
import SwiftyJSON
import AddressBookUI
import AddressBook

class Location: NSObject, MKAnnotation {
    private let name: String
    private let categories: [String]
    private let subCategory: String
    internal let coordinate: CLLocationCoordinate2D
    private let address: String
    
    init(_ name: String, categories: [String], subCategory: String, latitude: Double, longitude: Double) {
        self.name = name
        self.categories = categories
        self.subCategory = subCategory
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        var addr = "Address not found"
        CLGeocoder().reverseGeocodeLocation(loc) { (result: [CLPlacemark]?, err: Error?) in
            if let address = result?.first {
                let lines = address.addressDictionary?["FormattedAddressLines"] as! [String]
                addr = lines.joined(separator: "\n")
            }
        }
        self.address = addr
        
        super.init()
    }
    
    convenience init?(_ json: JSON) {
        guard let name = json["Name"].string else { return nil }
        guard let rawCategories = json["Category"].array else { return nil }
        let categories: [String] = rawCategories.map { $0.string! }
        var subCategory: String = ""
        if let sub = json["SubCategory"].string { subCategory = sub }
        
        let latitude = json["Latitude"].double
        let longitude = json["Longitude"].double
        guard latitude != nil && longitude != nil else { return nil }
        
        self.init(name, categories: categories, subCategory: subCategory, latitude: latitude!, longitude: longitude!)
    }
    
    // Override location description
    override var description: String {
        return "Category: \(categories) | SubCat: \(subCategory) | Name: \(name)"
    }
    
    func getName() -> String { return name }
    
    func getCategories() -> [String] { return categories }
    
    func getCoordinates() -> CLLocationCoordinate2D { return coordinate }
}
