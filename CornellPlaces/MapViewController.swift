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

typealias locationKey = String

enum KeyboardState {
    case hidden
    case showing
}

class MapViewController: UIViewController {
    
    var placesVC: UIViewController!
    
    var locationManager: CLLocationManager!
    var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 3600
    
    var searchBar: UITextField!
    var keyboardState: KeyboardState!
    
    var settingsButton: UIView!
    var placesButton: UIView!
    var userLocationButton: UIView!
    
    var tapGestureRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch data from server in background thread
        DispatchQueue.global(qos: .userInitiated).async {
            API.api.getLocationObjects()
            API.api.getCategories()
            API.api.getLocationCategoryMatchings()
//            print(PlacesData.categories)
//            print(PlacesData.locations)
            DispatchQueue.main.async {
                print("Back to main thread")
                self.placesVC = PlacesViewController()
            }
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        initializeMapView()
        initializeSearchBar()
        initializeButtons()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleTap(_:)))
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
        
        let initLoc = CLLocationCoordinate2D(latitude: 42.451284, longitude: -76.484155)
        let camera = MKMapCamera(lookingAtCenter: initLoc, fromDistance: regionRadius, pitch: 0.0, heading: 0.0)
        mapView.setCamera(camera, animated: false)
        view = mapView
    }
    
    // Initialize search bar
    func initializeSearchBar() {
        searchBar = UITextField(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 20, height: 36))
        searchBar.backgroundColor = UIColor.white
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchBar.layer.shadowRadius = 5
        searchBar.layer.masksToBounds = false
        searchBar.attributedPlaceholder = NSAttributedString(string: "Find places at Cornell", attributes: [NSForegroundColorAttributeName: UIColor.placesGray])
        searchBar.font = UIFont(name: "AvenirNext-Medium", size: 14)
        searchBar.textColor = UIColor.placesDarkGray
        searchBar.textAlignment = .left
        searchBar.clearsOnBeginEditing = false
        searchBar.clearButtonMode = .whileEditing
        searchBar.delegate = self
        searchBar.autocapitalizationType = .words
        searchBar.autocorrectionType = .no
        searchBar.keyboardAppearance = .dark
        let searchImageView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: searchBar.frame.height))
        let searchIcon = UIImageView(frame: CGRect(x: 7, y: 9, width: 18, height: 18))
        searchIcon.image = #imageLiteral(resourceName: "searchGray")
        searchImageView.addSubview(searchIcon)
        searchBar.leftView = searchImageView
        searchBar.leftViewMode = .always
        view.addSubview(searchBar)
        
        keyboardState = .hidden
    }
    
    func initializeButtons() {
        let topY = UIScreen.main.bounds.height - 76
        
        // Settings button
        settingsButton = UIView(frame: CGRect(x: 20, y: topY, width: 56, height: 56))
        settingsButton.backgroundColor = UIColor.white
        settingsButton.layer.shadowColor = UIColor.black.cgColor
        settingsButton.layer.shadowOpacity = 0.5
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        settingsButton.layer.shadowRadius = 5
        settingsButton.layer.cornerRadius = 4
        view.addSubview(settingsButton)
        
        // UserLocation button
        userLocationButton = UIView(frame: CGRect(x: UIScreen.main.bounds.width - (56 + 20), y: topY, width: 56, height: 56))
        userLocationButton.backgroundColor = UIColor.white
        userLocationButton.layer.shadowColor = UIColor.black.cgColor
        userLocationButton.layer.shadowOpacity = 0.5
        userLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        userLocationButton.layer.shadowRadius = 5
        userLocationButton.layer.cornerRadius = 4
        view.addSubview(userLocationButton)
        
        // Places button
        placesButton = UIView(frame: CGRect(x: userLocationButton.frame.minX - (56 + 20), y: topY, width: 56, height: 56))
        placesButton.backgroundColor = UIColor.white
        placesButton.layer.shadowColor = UIColor.black.cgColor
        placesButton.layer.shadowOpacity = 0.5
        placesButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        placesButton.layer.shadowRadius = 5
        placesButton.layer.cornerRadius = 4
        view.addSubview(placesButton)
    }
    
    // Center map view to specified location
//    func centerMap(_ location: CLLocationCoordinate2D) {
//        let region = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
//        mapView.setRegion(region, animated: true)
//    }

}

extension MapViewController: UIGestureRecognizerDelegate {
    func handleTap(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: view)
        if sender.state == .ended {
            if settingsButton.frame.contains(tapPoint) {
                print("Settings hit")
            } else if userLocationButton.frame.contains(tapPoint) {
                print("UserLocation hit")
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

// MARK - Map View delegate methods
extension MapViewController: MKMapViewDelegate {
    
}


// MARK - Location Manager delegate methods
extension MapViewController: CLLocationManagerDelegate {
    // Check for location authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}


//MARK - TextField delegate methods
extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        checkSearchResults { (loc) in
//            if loc.getName() != "" {
//                if self.selectMarkerIfOnMap(loc) == false {
//                    self.placeMarkers("none", locations: [loc])
//                }
//                self.view.endEditing(true)
//                self.keyboardState = .hidden
//            }
//        }
        view.endEditing(true)
        keyboardState = .hidden
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //        let oldSearch = searchBar.text
        //        for loc in currentMarkers{
        //            if loc.getName() == oldSearch {
        //                mapView.selectedMarker = nil
        //                loc.removePlaceMarker()
        //            }
        //        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        keyboardState = .showing
        return true
    }
    
//    func checkSearchResults(completion: (Location) -> Void) {
//        let search = searchBar.text?.lowercased()
//        for loc in Locations.allLocations{
//            if search == loc.getName().lowercaseString {
//                completion(loc)
//            }
//        }
//        completion(Location(category: [""], subCategory: "", name: "", latitude: 0, longitude: 0))
//    }
}

