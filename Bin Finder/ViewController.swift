//
//  ViewController.swift
//  Bin Finder
//
//  Created by Antonio Baldi on 11/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        locationManager.delegate = self
        mapView.delegate = self
        fetchBinsOnMap(bins)
        showUserLocation(mapView)
    }
    
    @objc func showUserLocation(_ sender: AnyObject) {
        print("\nStart of showUserLocation()")
        print("\nUser's location: lat=\(mapView.userLocation.coordinate.latitude), lon=\(mapView.userLocation.coordinate.longitude), title=\(mapView.userLocation.title!)")
        
        
        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
        case CLAuthorizationStatus.authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        default:
            fatalError()
        }
        
        print("\nEnd of showUserLocation()")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\nStart of locationManager(didChangeAuthorization)")
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == CLAuthorizationStatus.authorizedWhenInUse
            || authStatus == CLAuthorizationStatus.authorizedAlways {
            requestLocation()
        }
        
        print("\nEnd of locationManager(didChangeAuthorization)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\nStart of locationManager(didUpdateLocations)")
        
        zoomInLocation(locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let err = error as? CLError, err.code == .denied {
            manager.stopUpdatingLocation()
            return
        }
        print("\nlocationManager(): \(error.localizedDescription)")
    }
    
    private func requestLocation() {
        print("\requestLocation() called")
        
        // check if the location service is availalbe on that device
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        locationManager.requestLocation()
    }
    
    private func zoomInLocation(_ location: CLLocation) {
        print("\nzoomInUserLocation(): mapView[latitude]=\(location.coordinate.latitude), locationManager[latitude]=\(String(describing: location.coordinate.latitude))")
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: coordinateSpan)
        mapView.centerCoordinate = location.coordinate
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        // Tells the delegate that one of its annotation views was selected.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "carta"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            print("Nome della notazione \(annotation.title) ")
            switch annotation.title {
            case "Paper":
                anView?.image = UIImage(named:"prova")
                anView?.canShowCallout = true
            case "Glass":
                anView?.image = UIImage(named:"img1")
                anView?.canShowCallout = true
            case "Plastic & Metals":
                anView?.image = UIImage(named:"img2")
                anView?.canShowCallout = true
            case "Mixed waste":
                anView?.image = UIImage(named:"prova")
                anView?.canShowCallout = true
            case "Organic waste":
                anView?.image = UIImage(named:"prova")
                anView?.canShowCallout = true
            default:
                print("err")
            }
            
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView?.annotation = annotation
        }
        
        return anView
    }
    
    struct Bin {
        var type: String
        var lattitude: CLLocationDegrees
        var longtitude: CLLocationDegrees
    }
    
    let bins = [Bin(type: "Paper", lattitude: 40.7723, longtitude: 14.7899),
                Bin(type: "Glass", lattitude: 51.4816, longtitude: -0.191034),
                Bin(type: "Plastic & Metals", lattitude: 51.6033, longtitude: -0.065684),
                Bin(type: "Mixed waste", lattitude: 51.5383, longtitude: -0.016587),
                Bin(type: "Organic waste", lattitude: 53.4631, longtitude: -2.29139),
                Bin(type: "Anfield", lattitude: 53.4308, longtitude: -2.96096)]
    
    
    func fetchBinsOnMap(_ bins: [Bin]) {
        for bin in bins {
            let annotations = MKPointAnnotation()
            annotations.title = bin.type
            annotations.coordinate = CLLocationCoordinate2D(latitude: bin.lattitude, longitude: bin.longtitude)
            mapView.addAnnotation(annotations)
        }
    }
}

