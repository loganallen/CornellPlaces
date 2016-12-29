//
//  UIView+Extension.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/29/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

extension UIView {
    func rotate180Degrees(clockwise: Bool, duration: CFTimeInterval) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = clockwise ? -M_PI : 0
        rotation.toValue = clockwise ? 0 : -M_PI
        rotation.isAdditive = true
        rotation.duration = duration
        rotation.isRemovedOnCompletion = false
        rotation.fillMode = kCAFillModeForwards
        
        self.layer.add(rotation, forKey: "rotate")
    }
}
