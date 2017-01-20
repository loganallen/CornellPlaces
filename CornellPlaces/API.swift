//
//  API.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias locationKey = String

struct PlacesData {
    static var categories = [String: Category]()
    static var categoryList = [String]()
    static var locations = [locationKey: Location]()
}

class API {
    
    static let api = API()
    
    // Get all location objects
    func getLocationObjects() {
        // TODO: Replace with API call to backend
        let jsonArray = JSON(data: NSData(contentsOf: Bundle.main.url(forResource: "locationData", withExtension: "json")!) as Data? ?? NSData() as Data)
        
        for i in 0..<jsonArray.count {
            let loc = Location(json: jsonArray[i])!
            if let _ = PlacesData.locations[loc.uid] {
                print("Location already exists")
                exit(0)
            }
            PlacesData.locations[loc.uid] = loc
        }
    }
    
    // Get all category and subcategory information
    func getCategories() {
        // TODO: Replace with API call to backend
        let jsonArray = JSON(data: NSData(contentsOf: Bundle.main.url(forResource: "categoryData", withExtension: "json")!) as Data? ?? NSData() as Data)
        
        for i in 0..<jsonArray.count {
            if let obj = Category(json: jsonArray[i]) {
                if let _ = PlacesData.categories[obj.name] {
                    print("Category already exists!")
                    exit(0)
                }
                PlacesData.categories[obj.name] = obj
            }
        }
        
        PlacesData.categoryList = Array(PlacesData.categories.keys).sorted { $0 < $1 }
    }
    
    // Get all matchings of locations to categories
    func getLocationCategoryMatchings() {
        let jsonArray = JSON(data: NSData(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!) as Data? ?? NSData() as Data)
        
        for i in 0..<jsonArray.count {
            let json = jsonArray[i]
            guard let category = json["Category"].string else { return }
            guard let subCategory = json["SubCategory"].string else { return }
            guard let locIds = json["LocIds"].array else { return }
            if let categoryObj = PlacesData.categories[category] {
                categoryObj.addLocations(toSubCategory: subCategory, locationKeys: locIds.map({ $0.string! }))
            }
        }
    }
}
