//
//  Location.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import MapKit
import SwiftyJSON

class Location: NSObject, MKAnnotation {
    let uid: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    
    init(uid: String, name: String, latitude: Double, longitude: Double) {
        self.uid = uid
        self.name = name
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
    
    convenience init?(json: JSON) {
        guard let uid = json["LocId"].string else { return nil }
        guard let name = json["Name"].string else { return nil }
        guard let latitude = json["Latitude"].double else { return nil }
        guard let longitude = json["Longitude"].double else { return nil }
        
        self.init(uid: uid, name: name, latitude: latitude, longitude: longitude)
    }
    
    // Override location description
    override var description: String {
        return "LocId: \(uid) | Name: \(name)\n"
    }
}
