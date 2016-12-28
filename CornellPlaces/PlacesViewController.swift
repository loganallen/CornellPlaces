//
//  PlacesViewController.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var headerView: UIView!
    let cellIdentifier: String = "placesCell"
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var closeButton: UIButton!
    var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        print("Width: \(screenWidth), Height: \(screenHeight)")
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.backgroundColor = UIColor.white
        
        initializeHeaderView()
        closeButton = UIButton(frame: CGRect(x: screenWidth - 44, y: 26, width: 30, height: 30))
        closeButton.setBackgroundImage(UIImage(named: "close"), for: .normal)
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        closeButton.layer.shadowRadius = 2
        closeButton.layer.shadowOpacity = 0.6
        closeButton.addTarget(self, action: #selector(PlacesViewController.closeButtonPressed(_:)), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .right
        swipeGestureRecognizer.delegate = self
        swipeGestureRecognizer.addTarget(self, action: #selector(PlacesViewController.didSwipeView(_:)))
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    func initializeHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 90))
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.placesDarkRed.cgColor, UIColor.placesRed.cgColor]
        gradient.startPoint = CGPoint(x: 0.05, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.95, y: 0.5)
        gradient.frame = headerView.frame
        headerView.layer.insertSublayer(gradient, at: 0)
        
        view.addSubview(headerView)
    }
    
    func closeButtonPressed(_ sender: UIGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK - Table view delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.categorizedMapping.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        return cell
    }
}

extension PlacesViewController: UIGestureRecognizerDelegate {
    func didSwipeView(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            navigationController?.popViewController(animated: true)
        }
    }
}
