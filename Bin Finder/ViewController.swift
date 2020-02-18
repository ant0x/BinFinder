
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
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 500
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        locationManager.delegate = self
        fetchBinsOnMap(bins)
        showUserLocation(mapView)
    }
    
    
    @IBAction func centerMap(_ sender: Any) {
        let loc = locationManager.location
        if(loc != nil)
        {
            centerMapOnLocation(location: loc!)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                       latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    
    
    @IBAction func addBinButton(_ sender: Any) {
        let addBinView = AddBinViewController(nibName: "AddBinViewController", bundle: nil)
        addBinView.lattitude = mapView.userLocation.coordinate.latitude
        addBinView.longtitude = mapView.userLocation.coordinate.longitude
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
            zoomInLocation(manager.location!)
        }
        
        print("\nEnd of locationManager(didChangeAuthorization)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\nStart of locationManager(didUpdateLocations)")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //zoomInLocation(locations.last!)
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
    
    
    
    @objc func route(sender: cButton) {
        let location = sender.coordinate
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location, addressDictionary:nil))
        mapItem.name = sender.annotation.title!
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = ""
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        
        
        let mapsButton = cButton(annotation: annotation ,frame: CGRect(origin: CGPoint.zero,
                                                                         size: CGSize(width: 40, height: 40)))
        mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
        mapsButton.addTarget(self, action:#selector(route), for: .touchUpInside)
        
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            
            switch annotation.title {
            case "Paper":
                anView?.image = UIImage(named:"greenPin")
                anView?.canShowCallout = true
            case "Glass":
                print("eeee vetro")
                anView?.image = UIImage(named:"lightGreenPin")
                anView?.canShowCallout = true
            case "Plastic & Metals":
                anView?.image = UIImage(named:"lightBluePin")
                anView?.canShowCallout = true
            case "Mixed waste":
                anView?.image = UIImage(named:"pinkPin")
                anView?.canShowCallout = true
            case "Organic waste":
                anView?.image = UIImage(named:"Maps-icon")
                anView?.canShowCallout = true
            default:
                print("default")
            }
            anView?.rightCalloutAccessoryView = mapsButton
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView?.annotation = annotation
        }
        return anView
    }
    
    struct Bin {
        var type: String
        var latitude: CLLocationDegrees
        var longtitude: CLLocationDegrees
    }
    
    var bins = [Bin(type: "Paper", latitude: 40.7723, longtitude: 14.7899),
                Bin(type: "Glass", latitude: 41.7723, longtitude: 15.7899),
                Bin(type: "Plastic & Metals", latitude: 42.7723, longtitude: 16.7899),
                Bin(type: "Mixed waste", latitude: 39.7723, longtitude: 13.7899),
                Bin(type: "Organic waste", latitude: 43.7723, longtitude: 14.7899),
                Bin(type: "Paper", latitude: 40.7723, longtitude: 11.7899)]
    
    
    func fetchBinsOnMap(_ bins: [Bin]) {
        for bin in bins {
            let annotations = MKPointAnnotation()
            annotations.title = bin.type
            annotations.coordinate = CLLocationCoordinate2D(latitude: bin.latitude, longitude: bin.longtitude)
            mapView.delegate = self
            mapView.addAnnotation(annotations)
        }
    }
 
    
    
    
    
    
    
}

