//
//  MapViewController.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

enum KeyboardState {
    case hidden
    case showing
}

protocol PlacesDelegate {
    func didTapLocationCell(_ locationIds: [locationKey])
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate, PlacesDelegate {
    
    var placesVC: PlacesViewController!
    
    var locationManager: CLLocationManager!
    var mapView: MKMapView!
    let initLoc = CLLocationCoordinate2D(latitude: 42.451284, longitude: -76.484155)
    let initRadius: CLLocationDistance = 1800
    
    var searchBar: UITextField!
    var keyboardState: KeyboardState!
    var searchTableView: UITableView!
    let cellId = "searchCellId"
    var filteredLocations: [Location] = [Location]()
    
    var settingsButton: UIView!
    var placesButton: UIView!
    var userLocationButton: UIView!
    final let buttonSize: CGFloat = 58
    final let buttonImageSize: CGFloat = 24
    let buttonFont = UIFont(name: "AvenirNext-DemiBold", size: 11)
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    let mapIdentifier = "locationPin"
    
    var screenHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch data from server in background thread
        DispatchQueue.global(qos: .userInitiated).async {
            API.api.getLocationObjects()
            API.api.getCategories()
            API.api.getLocationCategoryMatchings()
            DispatchQueue.main.async {
                print("Back to main thread")
                self.placesVC = PlacesViewController()
                self.placesVC.placesDelegate = self
                self.placesVC.mapVC = self
            }
        }
        
        screenHeight = UIScreen.main.bounds.maxY
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        initializeMapView()
        initializeSearchBar()
        initializeButtons()
        initializeSearchTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleButtonTap(_:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Initialize the main map view
    func initializeMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsCompass = false
        centerMap(initLoc, animated: false)
        view = mapView
    }
    
    // Initialize search bar
    func initializeSearchBar() {
        searchBar = UITextField(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 20, height: 38))
        searchBar.backgroundColor = .white
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchBar.layer.shadowRadius = 5
        searchBar.layer.masksToBounds = false
        searchBar.attributedPlaceholder = NSAttributedString(string: "Find places at Cornell", attributes: [NSForegroundColorAttributeName: UIColor.placesGray])
        searchBar.font = UIFont(name: "AvenirNext-Medium", size: 14)
        searchBar.textColor = .placesDarkGray
        searchBar.textAlignment = .left
        searchBar.clearsOnBeginEditing = false
        searchBar.clearButtonMode = .whileEditing
        searchBar.delegate = self
        searchBar.autocapitalizationType = .words
        searchBar.autocorrectionType = .no
        searchBar.keyboardAppearance = .dark
        let searchImageView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: searchBar.frame.height))
        let searchIcon = UIImageView(frame: CGRect(x: 8, y: 10, width: 18, height: 18))
        searchIcon.image = #imageLiteral(resourceName: "searchGray")
        searchImageView.addSubview(searchIcon)
        searchBar.leftView = searchImageView
        searchBar.leftViewMode = .always
        view.addSubview(searchBar)
        
        keyboardState = .hidden
    }
    
    func initializeSearchTableView() {
        searchTableView = UITableView(frame: CGRect(x: 10, y: searchBar.frame.maxY, width: searchBar.frame.width, height: screenHeight-searchBar.frame.maxY))
        searchTableView.delegate = self
        searchTableView.dataSource = self
        print("suh")
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: cellId)
        searchTableView.showsVerticalScrollIndicator = true
        searchTableView.estimatedRowHeight = 50
        searchTableView.backgroundColor = .white
        searchTableView.separatorStyle = .none
        view.insertSubview(searchTableView, aboveSubview: searchBar)
        searchTableView.isHidden = true
        print("done")
    }
    
    func initializeButtons() {
        let topY = UIScreen.main.bounds.height - 72
        
        // Settings button
        settingsButton = UIView(frame: CGRect(x: 14, y: topY, width: buttonSize, height: buttonSize))
        settingsButton.backgroundColor = .white
        settingsButton.layer.shadowColor = UIColor.black.cgColor
        settingsButton.layer.shadowOpacity = 0.5
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        settingsButton.layer.shadowRadius = 5
        settingsButton.layer.cornerRadius = 4
        let settingsImage = UIImageView(frame: CGRect(x: (buttonSize-buttonImageSize)/2, y: (buttonSize-36)/2, width: buttonImageSize, height: buttonImageSize))
        settingsImage.image = #imageLiteral(resourceName: "settingsIcon")
        settingsButton.addSubview(settingsImage)
        let settingsLabel = UILabel(frame: CGRect(x: 0, y: 36, width: buttonSize, height: 20))
        settingsLabel.backgroundColor = .clear
        settingsLabel.font = buttonFont
        settingsLabel.textColor = .placesRed
        settingsLabel.textAlignment = .center
        settingsLabel.text = "Settings"
        settingsButton.addSubview(settingsLabel)
        view.addSubview(settingsButton)
        
        // UserLocation button
        userLocationButton = UIView(frame: CGRect(x: UIScreen.main.bounds.width - (buttonSize + 14), y: topY, width: buttonSize, height: buttonSize))
        userLocationButton.backgroundColor = .white
        userLocationButton.layer.shadowColor = UIColor.black.cgColor
        userLocationButton.layer.shadowOpacity = 0.5
        userLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        userLocationButton.layer.shadowRadius = 5
        userLocationButton.layer.cornerRadius = 4
        let userImage = UIImageView(frame: CGRect(x: (buttonSize-buttonImageSize)/2, y: (buttonSize-36)/2, width: buttonImageSize, height: buttonImageSize))
        userImage.image = #imageLiteral(resourceName: "userIcon")
        userLocationButton.addSubview(userImage)
        let userLabel = UILabel(frame: CGRect(x: 0, y: 36, width: buttonSize, height: 20))
        userLabel.backgroundColor = .clear
        userLabel.font = buttonFont
        userLabel.textColor = .placesRed
        userLabel.textAlignment = .center
        userLabel.text = "Me"
        userLocationButton.addSubview(userLabel)
        view.addSubview(userLocationButton)
        
        // Places button
        placesButton = UIView(frame: CGRect(x: userLocationButton.frame.minX - (buttonSize + 14), y: topY, width: buttonSize, height: buttonSize))
        placesButton.backgroundColor = .white
        placesButton.layer.shadowColor = UIColor.black.cgColor
        placesButton.layer.shadowOpacity = 0.5
        placesButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        placesButton.layer.shadowRadius = 5
        placesButton.layer.cornerRadius = 4
        let placesImage = UIImageView(frame: CGRect(x: (buttonSize-buttonImageSize)/2, y: (buttonSize-36)/2, width: buttonImageSize, height: buttonImageSize))
        placesImage.image = #imageLiteral(resourceName: "placesIconMultiple")
        placesButton.addSubview(placesImage)
        let placesLabel = UILabel(frame: CGRect(x: 0, y: 36, width: buttonSize, height: 20))
        placesLabel.backgroundColor = .clear
        placesLabel.font = buttonFont
        placesLabel.textColor = .placesRed
        placesLabel.textAlignment = .center
        placesLabel.text = "Places"
        placesButton.addSubview(placesLabel)
        view.addSubview(placesButton)
    }
    
    // PlacesDelegate method
    func didTapLocationCell(_ locationIds: [locationKey]) {
        mapView.removeAnnotations(mapView.annotations)
        var locations = [Location]()
        for locId in locationIds {
            if let loc = PlacesData.locations[locId] {
                locations.append(loc)
            }
        }
        print(locations)
        mapView.addAnnotations(locations)
        if (locations.count == 1) {
            mapView.selectAnnotation(locations.first!, animated: true)
        }
        let loc = locations.count > 1 ? initLoc : locations.first!.coordinate
        centerMap(loc)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.minY {
            adjustSearchTableViewFrame(keyboardHeight-searchBar.frame.maxY)
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.minY {
            adjustSearchTableViewFrame(keyboardHeight-searchBar.frame.maxY)
        }
    }
    
    // Update the search table view frame
    func adjustSearchTableViewFrame(_ bottomValue: CGFloat) {
        UIView.animate(withDuration: 0.4) { 
            self.searchTableView.frame = CGRect(x: 10, y: self.searchBar.frame.maxY, width: self.searchBar.frame.width, height: bottomValue)
        }
    }
    
    // Center map view to specified location
    func centerMap(_ location: CLLocationCoordinate2D, animated: Bool = true) {
        let region = MKCoordinateRegionMakeWithDistance(location, initRadius, initRadius)
        mapView.setRegion(region, animated: animated)
    }

    // Handle interface button tap
    func handleButtonTap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: view)
        if sender.state == .ended {
            if settingsButton.frame.contains(tapPoint) {
                print("Settings hit")
            } else if userLocationButton.frame.contains(tapPoint) {
                print("UserLocation hit")
                locationManager.startUpdatingLocation()
            } else if placesButton.frame.contains(tapPoint) {
                navigationController?.pushViewController(placesVC, animated: true)
            } else {
                if !searchBar.frame.contains(tapPoint) {
                    view.endEditing(true)
                    keyboardState = .hidden
                }
            }
        }
    }
}

// MARK - Search TableView delegate methods
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchTableViewCell
        return cell
    }

    
}

// MARK - Map View delegate methods
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Location {
            var annotationView: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: mapIdentifier) {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: mapIdentifier)
                annotationView.image = #imageLiteral(resourceName: "placesIcon")
                annotationView.centerOffset = CGPoint(x: 0, y: -annotationView.image!.size.height/2)
                annotationView.canShowCallout = true
//                let detailView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
//                detailView.backgroundColor = .white
//                detailView.layer.shadowColor = UIColor.black.cgColor
//                detailView.layer.shadowOpacity = 0.6
//                detailView.layer.shadowOffset = CGSize(width: 0, height: 2)
//                detailView.layer.shadowRadius = 4
//                annotationView.detailCalloutAccessoryView = detailView
            }
            return annotationView
        }
        return nil
    }
}


// MARK - Location Manager delegate methods
extension MapViewController: CLLocationManagerDelegate {
    // Check for location authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        status == .authorizedWhenInUse ? mapView.showsUserLocation = true : locationManager.requestWhenInUseAuthorization()
    }
    
    // Update map to users location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last! as CLLocation
        centerMap(loc.coordinate)
        locationManager.stopUpdatingLocation()
    }
}


//MARK - TextField delegate methods
extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        view.endEditing(true)
        keyboardState = .hidden
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        keyboardState = .showing
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let search = textField.text {
            
        }
    }
    
    
    
    
}

