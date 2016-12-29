//
//  PlacesViewController.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    
    let headerHeight: CGFloat = 90
    var headerView: UIView!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var closeButton: UIButton!
    var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    var tableView: UITableView!
    var currentlyExpandedSection: (section: Int, obj: Category)?
    let headerId: String = "categoryCell"
    let cellId: String = "locationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        
        view.backgroundColor = UIColor.white
        
        initializeHeaderView()
        
        swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .right
        swipeGestureRecognizer.delegate = self
        swipeGestureRecognizer.addTarget(self, action: #selector(PlacesViewController.didSwipeView(_:)))
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        initializeTableView()
    }
    
    func initializeHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight))
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.placesDarkRed.cgColor, UIColor.placesRed.cgColor]
        gradient.startPoint = CGPoint(x: 0.05, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.95, y: 0.5)
        gradient.frame = headerView.frame
        headerView.layer.insertSublayer(gradient, at: 0)
        
        closeButton = UIButton(frame: CGRect(x: screenWidth - 44, y: 26, width: 30, height: 30))
        closeButton.setBackgroundImage(UIImage(named: "close"), for: .normal)
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        closeButton.layer.shadowRadius = 2
        closeButton.layer.shadowOpacity = 0.6
        closeButton.addTarget(self, action: #selector(PlacesViewController.closeButtonPressed(_:)), for: .touchUpInside)
        
        headerView.addSubview(closeButton)
        view.addSubview(headerView)
    }
    
    // Initialize table view
    func initializeTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: headerHeight-20, width: screenWidth, height: screenHeight - headerHeight + 20))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        view.insertSubview(tableView, belowSubview: headerView)
    }
    
    func closeButtonPressed(_ sender: UIGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}


// MARK - Gesture recognizer delegate methods
extension PlacesViewController: UIGestureRecognizerDelegate {
    func didSwipeView(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            navigationController?.popViewController(animated: true)
        }
    }
}


// MARK - Table view delegate methods
extension PlacesViewController: UITableViewDelegate, UITableViewDataSource, CategoryHeaderDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PlacesData.categoryList.count
    }
    
    // Header cell methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryObj = PlacesData.categories[PlacesData.categoryList[section]]!
        return categoryObj.subCategories.count + categoryObj.numberOfLocations
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? CategoryTableViewHeader ?? CategoryTableViewHeader(reuseIdentifier: headerId)
        let categoryObj = PlacesData.categories[PlacesData.categoryList[section]]!
        header.categoryLabel.text = categoryObj.name
        header.categoryImage.image = UIImage(named: categoryObj.name.components(separatedBy: " ").first!.lowercased())
        header.delegate = self
        header.section = section
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CategoryTableViewHeader.headerHeight
    }
    
    // Normal cell methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CategoryTableViewCell ?? CategoryTableViewCell(style: .default, reuseIdentifier: cellId)
        
        let parentCategory = PlacesData.categories[PlacesData.categoryList[indexPath.section]]!
        let item = parentCategory.allItems[indexPath.row]
        if let loc = PlacesData.locations[item] {
            cell.nameLabel.text = loc.name
            cell.nameLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
            cell.markerImage.image = UIImage(named: "singlePlace")
            cell.locationIds = [item]
        } else {
            if item == "" {
                cell.nameLabel.text = "Show All"
                cell.locationIds = parentCategory.allItems.filter({ $0 != "" }) as [locationKey]
            } else {
                cell.nameLabel.text = item
                cell.locationIds = parentCategory.subCategories[item]
            }
            cell.nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
            cell.markerImage.image = UIImage(named: "multiplePlaces")
        }
        cell.isHidden = true
        if let (section, _) = currentlyExpandedSection {
            cell.isHidden = indexPath.section != section
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        print("\(cell.nameLabel.text) was selected")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let parentCategory = PlacesData.categories[PlacesData.categoryList[indexPath.section]]!
        return parentCategory.isExpanded! ? CategoryTableViewCell.cellHeight : 0
    }
    
    // CategoryHeaderDelegate method
    func toggleCategory(_ header: CategoryTableViewHeader, section: Int) {
        let categoryObj = PlacesData.categories[PlacesData.categoryList[section]]! as Category
        
        tableView.beginUpdates()
        
        var oldObj: Category?
        if let (curSec, curObj) = currentlyExpandedSection {
            // Collapse currently expanded section
            curObj.isExpanded = false
            (tableView.headerView(forSection: curSec) as! CategoryTableViewHeader).isExpanded = false
            for i in 0..<(curObj.subCategories.count + curObj.numberOfLocations) {
                tableView.reloadRows(at: [NSIndexPath(row: i, section: curSec) as IndexPath], with: .top)
            }
            oldObj = curObj
            currentlyExpandedSection = nil
        }
        if !header.isExpanded && oldObj != categoryObj {
            // Expand new section
            for i in 0..<(categoryObj.subCategories.count + categoryObj.numberOfLocations) {
                tableView.reloadRows(at: [NSIndexPath(row: i, section: section) as IndexPath], with: .bottom)
            }
            categoryObj.isExpanded = true
            header.isExpanded = true
            currentlyExpandedSection = (section, categoryObj)
        }
        
        tableView.endUpdates()

//        tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
    }
}
