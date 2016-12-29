//
//  Category.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/28/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Category: NSObject {
    var name: String!
    var subCategories: [String: [locationKey]]!
    lazy var allItems: [String] = self.getAllItems()
    var numberOfLocations: Int!
    var isExpanded: Bool!
    
    init(name: String, subCategories: [String]) {
        self.name = name
        self.subCategories = [String: [locationKey]]()
        for c in subCategories {
            self.subCategories[c] = [locationKey]()
        }
        self.numberOfLocations = 0
        self.isExpanded = false
    }
    
    convenience init?(json: JSON) {
        guard let name = json["Name"].string else { return nil }
        guard let subCategories = json["SubCategories"].array else { return nil }

        self.init(name: name, subCategories: subCategories.map({ $0.string! }))
    }
    
    // Append locationKey to subcategory if valid
    func addLocation(toSubCategory c: String, locationKey: locationKey) {
        guard var locations = subCategories[c] else {
            print("SubCategory doesn't exist!!!")
            exit(0)
        }
        locations.append(locationKey)
        numberOfLocations = numberOfLocations + 1
    }
    
    // Append list of locationKeys to subcategory
    func addLocations(toSubCategory c: String, locationKeys: [locationKey]) {
        subCategories[c] = locationKeys
        numberOfLocations = numberOfLocations + locationKeys.count
    }
    
    // Lazy initialization of allItems
    func getAllItems() -> [String] {
        var items = [String]()
        subCategories.forEach({ (sub,locs) in
            items.append(sub)
            locs.forEach({ (locKey) in
                items.append(locKey)
            })
        })
        return items
    }
    
    override var description: String {
        return "Category: \(name) | SubCategories: \(subCategories.keys) | NumOfLocs: \(numberOfLocations)\n"
    }
}
