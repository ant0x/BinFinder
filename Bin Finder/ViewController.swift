
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
    
    @IBOutlet weak var glassButton: UIButton!
    @IBOutlet weak var organicButton: UIButton!
    @IBOutlet weak var mixedButton: UIButton!
    @IBOutlet weak var plasticButton: UIButton!
    
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
    
    
    /*
     Aggiungere nella funzione snippet per la rimozione/ aggiunta pin sulla mappa
     
     ****
     SU ESEMPIO DI QUESTO METODO FARE ANCHE PER GLI ALTRI BUTTON
     ****
     
     
     
     */
    @IBAction func glassClick(_ sender: Any) {
        print("Button glass clicked\n")
        if glassButton.isSelected {
            //glassButton era gia stato selezionato
            //rendere il button grigio
            //let image = UIImage(named: "glassCross") as UIImage?
            //self.glassButton.setImage(image, for: .normal)
            self.glassButton.isSelected = false
        } else {
            //glassButton non era selezionato
            //rendere il button abilitato
            //let image = UIImage(named: "glass") as UIImage?
            //self.glassButton.setImage(image, for: .normal)
            self.glassButton.isSelected = true
        }
    }
    
    /*
    Aggiungere nella funzione snippet per la rimozione/ aggiunta pin sulla mappa
    */
    @IBAction func mixedClick(_ sender: Any) {
        print("Button mixed clicked\n")
        if mixedButton.isSelected {
            //fai sparire qui il pin
            let image = UIImage(named: "mixedCross") as UIImage?
            self.mixedButton.setImage(image, for: .normal)
            self.mixedButton.isSelected = false
        } else {
            //fai apparire qui il pin
            let image = UIImage(named: "mixed") as UIImage?
            self.mixedButton.setImage(image, for: .normal)
            self.mixedButton.isSelected = true
        }
    }
    
    /*
    Aggiungere nella funzione snippet per la rimozione/ aggiunta pin sulla mappa
    */
    @IBAction func organicClick(_ sender: Any) {
        print("Button organic clicked\n")
        if organicButton.isSelected {
                  //fai sparire qui il pin
                  let image = UIImage(named: "organicCross") as UIImage?
                  self.organicButton.setImage(image, for: .normal)
                  self.organicButton.isSelected = false
              } else {
                  //fai apparire qui il pin
                  let image = UIImage(named: "organic") as UIImage?
                  self.organicButton.setImage(image, for: .normal)
                  self.organicButton.isSelected = true
              }
    }
    
    /*
    Aggiungere nella funzione snippet per la rimozione/ aggiunta pin sulla mappa
    */
    @IBAction func plasticClick(_ sender: Any) {
        print("Button plastic clicked\n")
        if plasticButton.isSelected {
            //fai sparire qui il pin
            let image = UIImage(named: "plasticCross") as UIImage?
            self.plasticButton.setImage(image, for: .normal)
            self.plasticButton.isSelected = false
        } else {
            //fai apparire qui il pin
            let image = UIImage(named: "plastic") as UIImage?
            self.plasticButton.setImage(image, for: .normal)
            self.plasticButton.isSelected = true
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
    
    //questa funzione deve essere chiamata quando lo user vuole indicazioni per arrivare al cestino
    func onIndicationRequest(sourceLocationLatitude: CLLocationDegrees, sourceLocationLongitude: CLLocationDegrees, destinationLocationLatitude: CLLocationDegrees, destinationLocationLongitude: CLLocationDegrees) {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: sourceLocationLatitude, longitude: sourceLocationLongitude)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationLocationLatitude, longitude: destinationLocationLongitude)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions == \(error.localizedDescription)")
                }
                return
            }
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        self.mapView.delegate = self
        
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
        print("yoooo")
        print(sender)
        
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
                anView?.image = UIImage(named:"paper")
                anView?.canShowCallout = true
            case "Glass":
                print("eeee vetro")
                anView?.image = UIImage(named:"glass")
                anView?.canShowCallout = true
            case "Plastic & Metals":
                anView?.image = UIImage(named:"plastic")
                anView?.canShowCallout = true
            case "Mixed waste":
                anView?.image = UIImage(named:"mixed")
                anView?.canShowCallout = true
            case "Organic waste":
                anView?.image = UIImage(named:"organic")
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
    
    

    
    func fetchBinsOnMap(_ bins: [BinStruct]) {
        for annotation in mapView.annotations
        {
            mapView.removeAnnotation(annotation)
        }
 
        for bin in bins {
            let annotations = MKPointAnnotation()
            annotations.title = bin.type
            annotations.coordinate = CLLocationCoordinate2D(latitude: bin.latitude, longitude: bin.longtitude)
            mapView.delegate = self
            mapView.addAnnotation(annotations)
        }
    }
    
    let button = AddBinViewController(nibName: "AddBinViewController", bundle: nil)
    
    @IBAction func addBinButton(_ sender: Any) {
        print(locationManager.location!.coordinate)
        
    }

    func reload()
    {
        print(button.isBeingDismissed)
        fetchBinsOnMap(bins)
    }

    
 
   
    

    
    func applyRoundCorner(_ object:AnyObject) {
        object.layer?.cornerRadius = object.frame.size.width / 2
        object.layer?.masksToBounds = true
    }
    
}

