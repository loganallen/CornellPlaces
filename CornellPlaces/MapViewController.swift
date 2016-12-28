//
//  MapViewController.swift
//  CornellPlaces
//
//  Created by Logan Allen on 12/27/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 3600

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.gray
        
        mapView = MKMapView()
        setupMap()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view = mapView
        
    }
    
    // Set up map view attributes
    func setupMap() {
        mapView.mapType = .standard
        let initLoc = CLLocationCoordinate2D(latitude: 42.451284, longitude: -76.484155)
        let camera = MKMapCamera(lookingAtCenter: initLoc, fromDistance: regionRadius, pitch: 0.0, heading: 0.0)
        mapView.setCamera(camera, animated: false)
    }
    
    
    
    // Center map view to specified location
//    func centerMap(_ location: CLLocationCoordinate2D) {
//        let region = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
//        mapView.setRegion(region, animated: true)
//    }

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

