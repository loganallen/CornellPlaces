//
//  CategoryTableViewHeader.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/28/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

protocol CategoryHeaderDelegate {
    func toggleCategory(_ header: CategoryTableViewHeader, section: Int)
}

class CategoryTableViewHeader: UITableViewHeaderFooterView {
    
    static let headerHeight: CGFloat = 60.0

    var categoryImage: UIImageView!
    var categoryLabel: UILabel!
    var arrowImage: UIImageView!
    var customSeparator: UIView!
    
    var isExpanded: Bool!
    var delegate: CategoryHeaderDelegate?
    var section: Int?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        isExpanded = false
        
        categoryImage = UIImageView(frame: CGRect(x: 16, y: 10, width: 40, height: 40))
        contentView.addSubview(categoryImage)
        
        arrowImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 46, y: 18, width: 26, height: 26))
        arrowImage.image = #imageLiteral(resourceName: "downArrow")
        contentView.addSubview(arrowImage)
        
        categoryLabel = UILabel(frame: CGRect(x: categoryImage.frame.maxX + 12, y: 16, width: arrowImage.frame.minX - (categoryImage.frame.maxX + 24), height: 30))
        categoryLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        categoryLabel.textColor = UIColor.placesRed
        contentView.addSubview(categoryLabel)
        
        customSeparator = UIView(frame: CGRect(x: 20, y: 59, width: UIScreen.main.bounds.width - 20, height: 1))
        customSeparator.backgroundColor = UIColor.placesGray
        contentView.addSubview(customSeparator)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CategoryTableViewHeader.categoryCellTapped(_:)))
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func categoryCellTapped(_ sender: UITapGestureRecognizer) {
        delegate?.toggleCategory(self, section: section!)
    }
    
    // Animate arrow according to section expansion
    func setExpanded(willExpand: Bool) {
        arrowImage.rotate180Degrees(clockwise: !willExpand, duration: 0.3)
        isExpanded = willExpand
    }
    
}
