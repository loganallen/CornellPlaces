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
    
    static let headerHeight: CGFloat = 90.0

    var wrapperView: UIView!
    var categoryImage: UIImageView!
    var categoryLabel: UILabel!
    var arrowImage: UIImageView!
    var customSeparator: UIView!
    
    var isExpanded: Bool!
    var delegate: CategoryHeaderDelegate?
    var section: Int?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        isExpanded = false
        
        wrapperView = UIView(frame: CGRect(x: 10, y: 4, width: UIScreen.main.bounds.width - 40, height: CategoryTableViewHeader.headerHeight - 16))
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.placesDarkRed.cgColor, UIColor.placesRed.cgColor]
        gradient.startPoint = CGPoint(x: 0.05, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.95, y: 0.5)
        gradient.frame = wrapperView.frame
        wrapperView.layer.insertSublayer(gradient, at: 0)
        wrapperView.layer.cornerRadius = 4
        
        categoryImage = UIImageView(frame: CGRect(x: 26, y: wrapperView.frame.midY - 25, width: 50, height: 50))
        wrapperView.addSubview(categoryImage)
        
        arrowImage = UIImageView(frame: CGRect(x: wrapperView.frame.maxX - 40, y: wrapperView.frame.midY - 10, width: 20, height: 20))
        arrowImage.image = #imageLiteral(resourceName: "downArrow")
        wrapperView.addSubview(arrowImage)
        
        categoryLabel = UILabel(frame: CGRect(x: categoryImage.frame.maxX + 16, y: wrapperView.frame.midY - 15, width: arrowImage.frame.minX - (categoryImage.frame.maxX + 16), height: 30))
        categoryLabel.font = UIFont(name: "AvenirNext-Medium", size: 19)
        categoryLabel.textColor = .white
        wrapperView.addSubview(categoryLabel)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CategoryTableViewHeader.categoryCellTapped(_:)))
        wrapperView.addGestureRecognizer(gestureRecognizer)
        
        contentView.addSubview(wrapperView)
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
