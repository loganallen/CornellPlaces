//
//  CategoryTableViewCell.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/28/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 44.0
    
    var nameLabel: UILabel!
    var markerImage: UIImageView!
    var customSeparator: UIView!
    var locationIds: [locationKey]!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.placesLightGray
        selectionStyle = .none
        
        markerImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: (bounds.height - 30)/2 + 1, width: 30, height: 30))
        markerImage.backgroundColor = UIColor.gray
        addSubview(markerImage)
        
        nameLabel = UILabel(frame: CGRect(x: 40, y: (bounds.height - 30)/2 + 1, width: markerImage.frame.minX - 46, height: 30))
        nameLabel.textColor = UIColor.black
        addSubview(nameLabel)
        
        customSeparator = UIView(frame: CGRect(x: 32, y: 43, width: UIScreen.main.bounds.width - 32, height: 1))
        customSeparator.backgroundColor = UIColor.placesGray
        addSubview(customSeparator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
