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

protocol LocationDelegate {
    func didTapLocation(_ id: String)
    func didTapCategory(_ category: String)
}

struct Locations {
    static var categorizedMapping = [String: [locationKey]]()
    static var mapping = [locationKey: Location]()
}

class MapViewController: UIViewController {
    
    var placesVC: UIViewController!
    
    var locationManager: CLLocationManager!
    var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 3600
    
    var placesButton: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        initializeMapView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.getLocationObjects()
            DispatchQueue.main.async {
                print("Back to main thread")
                self.placesVC = PlacesViewController()
            }
        }
        
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
    
    func initializeButtons() {
        let topY = UIScreen.main.bounds.height - 66
        placesButton = UIView(frame: CGRect(x: 16, y: topY, width: 50, height: 50))
        placesButton.backgroundColor = UIColor.white
        placesButton.layer.shadowColor = UIColor.black.cgColor
        placesButton.layer.shadowOpacity = 0.5
        placesButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        placesButton.layer.shadowRadius = 5
        view.addSubview(placesButton)
    }
    
    // Get all location objects
    func getLocationObjects() {
        // TODO: Replace with API call on backend
        
        let jsonArray = JSON(data: NSData(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!) as Data? ?? NSData() as Data)
       
        for i in 0..<jsonArray.count {
            let json = jsonArray[i]
            guard let id = json["UId"].string else {
                print("No location ID found!!!")
                exit(0)
            }
            let loc = Location(json)
            saveLocation(id, loc!)
        }
    }
    
    // Add location object to the static variables
    func saveLocation(_ id: locationKey, _ loc: Location){
        for cat in loc.getCategories() {
            if var map = Locations.categorizedMapping[cat] {
                map.append(id)
            } else {
                Locations.categorizedMapping[cat] = [id]
            }
        }
        if let _ = Locations.mapping[id] {
            print("Non-unique ID!!!")
            exit(0)
        }
        Locations.mapping[id] = loc
//        print("Length: \(Locations.mapping.count)")
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
            if placesButton.frame.contains(tapPoint) {
                print("Tapped places button.")
                navigationController?.pushViewController(placesVC, animated: true)
            }
        }
    }
}

extension MapViewController: LocationDelegate {
    internal func didTapLocation(_ locationId: String) {
        return
    }
    internal func didTapCategory(_ category: String) {
        return
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

