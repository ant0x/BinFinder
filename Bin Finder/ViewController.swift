
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
        mapView.delegate = self
        fetchBinsOnMap(bins)
        showUserLocation(mapView)
        /*
         let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
         centerMapOnLocation(location: initialLocation)
         */
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
    
    
   
    @objc func route(sender: Any) {
        //let location = view.annotation
        
            //let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location!.coordinate, addressDictionary:nil))
        
            //mapItem.name = (view.annotation?.title)!
            //mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView) {
        // Tells the delegate that one of its annotation views was selected.
        // let rightButton = UIButton(type: .detailDisclosure)
        // view.rightCalloutAccessoryView = rightButton
        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                size: CGSize(width: 40, height: 40)))
        mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
        mapsButton.addTarget(view, action:#selector(route), for: .touchUpInside)
        view.rightCalloutAccessoryView = mapsButton
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        
        
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "paper"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            //print("Nome della notazione \(annotation.title) ")
            switch annotation.title {
            case "Paper":
                anView?.image = UIImage(named:"greenPin")
                anView?.canShowCallout = true
            case "Glass":
                anView?.image = UIImage(named:"lighGreenPin")
                anView?.canShowCallout = true
                
            case "Plastic & Metals":
                anView?.image = UIImage(named:"lightBluePin")
                anView?.canShowCallout = true
            case "Mixed waste":
                anView?.image = UIImage(named:"pinkPin")
                anView?.canShowCallout = true
            case "Organic waste":
                anView?.image = UIImage(named:"greenPin")
                anView?.canShowCallout = true
            default:
                print("default")
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
    /*
     override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     addBottomSheetView()
     }
     
     //bottom sheet appear
     func addBottomSheetView() {
     // 1- Init bottomSheetVC
     let bottomSheetVC = BottomSheetViewController()
     
     // 2- Add bottomSheetVC as a child view
     self.addChild(bottomSheetVC)
     self.view.addSubview(bottomSheetVC.view)
     bottomSheetVC.didMove(toParent: self)
     
     // 3- Adjust bottomSheet frame and initial position.
     let height = view.frame.height
     let width  = view.frame.width
     bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
     }
     //
     */
    /*private var originalPullUpControllerViewSize: CGSize = .zero
     
     
     private func addPullUpController(animated: Bool) {
     let pullUpController = makeSearchViewControllerIfNeeded()
     _ = pullUpController.view // call pullUpController.viewDidLoad()
     addPullUpController(pullUpController,
     initialStickyPointOffset: pullUpController.initialPointOffset,
     animated: animated)
     }
     
     private func makeSearchViewControllerIfNeeded() -> SearchViewController {
     let currentPullUpController = children
     .filter({ $0 is SearchViewController })
     .first as? SearchViewController
     let pullUpController: SearchViewController = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
     pullUpController.initialState = .expanded
     
     if originalPullUpControllerViewSize == .zero {
     originalPullUpControllerViewSize = pullUpController.view.bounds.size
     }
     
     return pullUpController
     }
     */
    
    @IBAction func prova(_ sender: Any) {
        
        //mapItem.name = annotation.title!
        
        
        
        
        let coordinate = CLLocationCoordinate2DMake(37.2, 22.9)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Bin"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

