//
//  ViewController.swift
//  Bin Finder
//
//  Created by Antonio Baldi on 11/02/2020.
//  Copyright © 2020 Antonio Baldi. All rights reserved.
//
import MapKit
import UIKit
class ViewController: UIViewController, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    /*
    var showCompass : Bool
    var showScale : Bool
    var ShowBuildngs : Bool
    */
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
      super.viewDidLoad()
      map.showsUserLocation = true
     fetchBinsOnMap(bins)
        map.delegate = self
        
    
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
                anView?.image = UIImage(named:"prova")
                anView?.canShowCallout = true
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
    
    let bins = [Bin(type: "Emirates Stadium", lattitude: 40.7723, longtitude: 14.7899),
                    Bin(type: "Stamford Bridge", lattitude: 51.4816, longtitude: -0.191034),
                    Bin(type: "White Hart Lane", lattitude: 51.6033, longtitude: -0.065684),
                    Bin(type: "Olympic Stadium", lattitude: 51.5383, longtitude: -0.016587),
                    Bin(type: "Old Trafford", lattitude: 53.4631, longtitude: -2.29139),
                    Bin(type: "Anfield", lattitude: 53.4308, longtitude: -2.96096)]
    
    
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        // Show alert letting the user know they have to turn this on.
      }
    }
    
    func checkLocationAuthorization() {
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        map.showsUserLocation = true
    
      // For these case, you need to show a pop-up telling users what's up and how to turn on permisneeded if needed
      case .denied:
        break
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        map.showsUserLocation = true
      case .restricted:
        break
      case .authorizedAlways:
        break
      @unknown default:
        break
        }
    }
    
    func fetchBinsOnMap(_ bins: [Bin]) {
    for bin in bins {
    let annotations = MKPointAnnotation()
      annotations.title = bin.type
      annotations.coordinate = CLLocationCoordinate2D(latitude: bin.lattitude, longitude: bin.longtitude)
      map.addAnnotation(annotations)
    }
    }
        
    

}
