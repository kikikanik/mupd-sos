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
    
    let profileService = ProfileService.shared
    
    //map
    var locationManager: CLLocationManager!
    
    let regionRadius: CLLocationDistance = 1000
    
    var centered = false
    
    //arrays to hold each Annotation
    //var myNotifcationAnnotations: [MKPointAnnotation] = []
    var notificationAnnotations:[NotificationAnnotation] = []
    var selectedNotificationAnnotation: NotificationAnnotation?
    
    var editedPinDrop: PinDrop?

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
        //NotificationCenter.default.post(name: Notification.Name(rawValue:  kSOSNotificaionsChanged), object: self)
    
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        centered = true
    }
    
    func setUpMap() {
        
        let centerLocationLat = 40.2803
        let centerLocationLong = -74.0054
        
        let centerLocation = CLLocation(latitude: centerLocationLat, longitude: centerLocationLong)
        
        centerMapOnLocation(location: centerLocation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard (annotation is NotificationAnnotation) else {
            return nil
        }
        let identifier = "notification"

        var annotationView = MKMarkerAnnotationView()
        
        if annotation is NotificationAnnotation {
            if let dequeuedAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                annotationView = dequeuedAnnotation
            } else {
                let thisAnnotation = annotation as! NotificationAnnotation
                annotationView.glyphTintColor = .white
                annotationView.canShowCallout = true
                
                let pindropImageView = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 50.0)))
                if let _ = thisAnnotation.title {
                    switch thisAnnotation.title! {
                    case "Medical Emergency":
                        pindropImageView.setBackgroundImage(UIImage(named: "medical"), for: UIControl.State())
                    case "Mental Emergency":
                        pindropImageView.setBackgroundImage(UIImage(named: "mental"), for: UIControl.State())
                    case "Gas Leak":
                        pindropImageView.setBackgroundImage(UIImage(named: "gas"), for: UIControl.State())
                    case "Car Accident":
                        pindropImageView.setBackgroundImage(UIImage(named: "accident"), for: UIControl.State())
                    case "Car Problem":
                        pindropImageView.setBackgroundImage(UIImage(named: "carproblem"), for: UIControl.State())
                    case "Suspicious Person":
                        pindropImageView.setBackgroundImage(UIImage(named: "susperson"), for: UIControl.State())
                    case "Shooter":
                        pindropImageView.setBackgroundImage(UIImage(named: "shooter"), for: UIControl.State())
                    case "Rabid Animal":
                        pindropImageView.setBackgroundImage(UIImage(named: "rabidanimal"), for: UIControl.State())
                    default:
                        pindropImageView.setBackgroundImage(UIImage(systemName: "questionmark.square.dashed"), for: UIControl.State())
                    }
                } else {
                    pindropImageView.setBackgroundImage(UIImage(systemName: "questionmark.square.dashed"), for: UIControl.State())
                }
                let pindropColor = thisAnnotation.color
                if let _ = thisAnnotation.importance {
                    switch thisAnnotation.importance! {
                    case 1:
                        thisAnnotation.color = .yellow
                    case 2:
                        thisAnnotation.color = .orange
                    case 3:
                        thisAnnotation.color = .red
                    default:
                        thisAnnotation.color = .blue
                    }
                } else {
                    thisAnnotation.color = .green
                }
                annotationView.leftCalloutAccessoryView = pindropImageView
                annotationView.markerTintColor = pindropColor
            }
            return annotationView
        } else {
            let annotationView = MKMarkerAnnotationView()
            annotationView.image = UIImage(systemName: "bubble.left.and.exclamationmark.bubble.right.fill")
            annotationView.canShowCallout = true
            
            return annotationView
        }
        
    }
    
    @objc
    func notificationsReceived() {
        //every time theres new data, this will be called
        //for loop through all notifs and display
        //pinDropService
        notificationAnnotations.removeAll()
        
        mapView.removeAnnotations(mapView.annotations)
        
        for notification in pinDropService.notifications {
            //coordinates & userID
            
            let pin = NotificationAnnotation(title: notification.notifName, subtitle: notification.identity, coordinate: CLLocationCoordinate2D(latitude: notification.reportedLocationLat, longitude: notification.reportedLocationLong), color: (notification.importance == 1) ? UIColor.red : UIColor.yellow, pinDropID: notification.pinDropId, importance: notification.importance)
              /*
               let pin = NotificationAnnotation(title: notification.notifName, subtitle: notification.identity, notifType: notification.notifName, coordinate: CLLocationCoordinate2D(latitude: notification.reportedLocationLat, longitude: notification.reportedLocationLong), color: (notification.importance == 0) ? UIColor.red : UIColor.yellow)
               */
                                              
            notificationAnnotations.append(pin)
        }
        mapView.addAnnotations(notificationAnnotations)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.leftCalloutAccessoryView == control {
        let thisAnnotation = view.annotation
            if thisAnnotation is NotificationAnnotation {
                selectedNotificationAnnotation = thisAnnotation as? NotificationAnnotation
                mapView.deselectAnnotation(view.annotation, animated: false)
                performSegue(withIdentifier: "notificationSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if selectedNotificationAnnotation != nil {
            if(segue.identifier == "notificationSegue") {
                let dvc = segue.destination as! PinDropDetailViewController
                dvc.selectedItem = pinDropService.getPinDropInfo(forPinDropId: selectedNotificationAnnotation!.pinDropID)
            }
        }
    }
}
