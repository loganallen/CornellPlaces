//
//  UIColor+Shared.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc static let placesDarkRed = UIColor.colorFromCode(0x901515)
    @nonobjc static let placesRed = UIColor.colorFromCode(0xB32525)
    @nonobjc static let placesLightRed = UIColor.colorFromCode(0xE43939)
    @nonobjc static let placesDarkGray = UIColor.colorFromCode(0x4A4A4A)
    @nonobjc static let placesGray = UIColor.colorFromCode(0x9B9B9B)
    @nonobjc static let placesLightGray = UIColor.colorFromCode(0xE9E9E9)
    
    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
