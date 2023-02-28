//
//  ViewController.swift
//  MapDemo4Lak
//
//  Created by Kinneret Kanik on 08/02/2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    //Service (Model) file connecters
    let userService = UserService.shared
    
    let pinDropService = PinDropService.shared
        
    //map
    var locationManager: CLLocationManager!
    
    let regionRadius: CLLocationDistance = 1000
    
    var centered = false
    
    //for the pins
    //var myNotifcationAnnotations: [MKPointAnnotation] = []
    var mapAnnotations:[NotificationAnnotation] = []

    let pinColors:[UIColor] = [.yellow, .green, .red]

    
    //mapView outlet
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        setUpMap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationsReceived), name: Notification.Name(rawValue:  kSOSNotificaionsChanged), object: nil)
        
        pinDropService.observeNotifications()
    
    }
    
    func setUpMap() {
        
        let centerLocationLat = 40.2803
        let centerLocationLong = -74.0054
        
        let centerLocation = CLLocation(latitude: centerLocationLat, longitude: centerLocationLong)
        
        centerMapOnLocation(location: centerLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        centered = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            
            if let anAnnotation = annotation as? NotificationAnnotation {
                let identifier = "Annotation"
                let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.markerTintColor = anAnnotation.color
                annotationView = pinView
            }
            annotationView?.canShowCallout = false
        }
        else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    @objc
    func notificationsReceived() {
        //every time theres new data, this will be called
        //for loop through all notifs and display

        //myNotifcationAnnotations.removeAll()
        
        mapAnnotations.removeAll()
        
        mapView.removeAnnotations(mapView.annotations)
        
        for notification in pinDropService.sosNotifications {
           
            //coordinates & userID
            let pin = NotificationAnnotation(title: notification.notifName, subtitle: notification.identity, coordinate: CLLocationCoordinate2D(latitude: notification.reportedLocationLat, longitude: notification.reportedLocationLong), color: (notification.importance == 0) ? UIColor.red : UIColor.yellow)
            
             //myNotifcationAnnotations.append(pin)
            mapAnnotations.append(pin)

        }
       // mapView.addAnnotations(myNotifcationAnnotations)
        mapView.addAnnotations(mapAnnotations)
    }
    
}
