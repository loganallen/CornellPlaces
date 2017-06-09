//
//  PlacesHeaderView.swift
//  CornellPlaces
//
//  Created by Logan Allen on 6/7/17.
//  Copyright © 2017 Logan Allen. All rights reserved.
//

import UIKit

protocol PlacesHeaderDelegate {
    func closePlacesVC()
}

class PlacesHeaderView: UIView {
    
    static let minHeaderHeight: CGFloat = 60
    static let maxHeaderHeight: CGFloat = 110
    
    var placesImage: UIImageView!
    var placesTitle: UILabel!
    var closeButton: UIButton!
    var delegate: PlacesHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        placesImage = UIImageView(frame: CGRect(x: frame.midX - 22, y: frame.midY - 22, width: 44, height: 44))
        placesImage.image = #imageLiteral(resourceName: "placesIconMultiple")
        addSubview(placesImage)
        
        placesTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        closeButton = UIButton(frame: CGRect(x: frame.width - 54, y: 36, width: 30, height: 30))
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "close_red"), for: .normal)
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        closeButton.layer.shadowRadius = 2
        closeButton.layer.shadowOpacity = 0.2
        closeButton.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
        
        addSubview(closeButton)
    }
    
    func closeButtonPressed(_ sender: UIButton) {
        delegate?.closePlacesVC()
    }

}
