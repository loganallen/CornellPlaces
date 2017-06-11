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
        
        let wrapperSize = CGSize(width: UIScreen.main.bounds.width - 24, height: CategoryTableViewHeader.headerHeight - 12)
        wrapperView = UIView(frame: CGRect(origin: CGPoint(x: 12, y: 6), size: wrapperSize))
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.placesDarkRed.cgColor, UIColor.placesLightRed.cgColor]
        gradient.startPoint = CGPoint(x: 0.05, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.95, y: 0.5)
        gradient.frame = CGRect(origin: .zero, size: wrapperSize)
        wrapperView.layer.insertSublayer(gradient, at: 0)
        wrapperView.layer.cornerRadius = 4
        wrapperView.layer.masksToBounds = true
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 2)
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowRadius = 5
        wrapperView.layer.shadowOpacity = 0.4
        
        categoryImage = UIImageView(frame: CGRect(x: 26, y: wrapperView.bounds.midY - 25, width: 50, height: 50))
        wrapperView.addSubview(categoryImage)
        
        arrowImage = UIImageView(frame: CGRect(x: wrapperView.bounds.maxX - 40, y: wrapperView.bounds.midY - 10, width: 20, height: 20))
        arrowImage.image = #imageLiteral(resourceName: "downArrow")
        wrapperView.addSubview(arrowImage)
        
        categoryLabel = UILabel(frame: CGRect(x: categoryImage.frame.maxX + 16, y: wrapperView.bounds.midY - 15, width: arrowImage.frame.minX - (categoryImage.frame.maxX + 16), height: 30))
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
