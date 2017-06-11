//
//  CategoryTableViewCell.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/28/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 36.0
    
    var nameLabel: UILabel!
    var markerImage: UIImageView!
    var customSeparator: UIView!
    var locationIds: [locationKey]!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        markerImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 72, y: 5, width: 26, height: 26))
        addSubview(markerImage)
        
        nameLabel = UILabel(frame: CGRect(x: 42, y: 3, width: markerImage.frame.minX - 50, height: 30))
        nameLabel.textColor = UIColor.placesDarkRed
        addSubview(nameLabel)
        
        customSeparator = UIView(frame: CGRect(x: 30, y: 35, width: UIScreen.main.bounds.width - 60, height: 1))
        customSeparator.backgroundColor = UIColor.placesDarkRed
        addSubview(customSeparator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
