//
//  ViewController.swift
//  MapDemo4Lak
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
    var notificationAnnotations:[NotificationAnnotation] = []
    
    var profileAnnotations: [ProfileAnnotation] = []
    var selectedProfileAnnotation: ProfileAnnotation?
   
    var selectedNotificationAnnotation: NotificationAnnotation?
    
    var editedPinDrop: PinDrop?

    let pinColors:[UIColor] = [.red, .orange, .yellow]

    
    var selectedItem: PinDrop!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationsReceived), name: Notification.Name(rawValue:  kSOSNotificationsChanged), object: nil)
        
        pinDropService.observeNotifications()
    
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
                    case "Car Hazard":
                        pindropImageView.setBackgroundImage(UIImage(named: "carhazard"), for: UIControl.State())
                    case "Suspicious Person":
                        pindropImageView.setBackgroundImage(UIImage(named: "susperson"), for: UIControl.State())
                    case "Active Shooter":
                        pindropImageView.setBackgroundImage(UIImage(named: "shooter"), for: UIControl.State())
                    case "Rabid Animal":
                        pindropImageView.setBackgroundImage(UIImage(named: "rabidanimal"), for: UIControl.State())
                    case "Fire":
                        pindropImageView.setBackgroundImage(UIImage(named: "fire"), for: UIControl.State())
                   // case "Report Other":
                   //     pindropImageView.setBackgroundImage(UIImage(named: "reportother"), for: UIControl.State())
                    default:
                        pindropImageView.setBackgroundImage(UIImage(named: "reportother"), for: UIControl.State())
                    }
                } else {
                    pindropImageView.setBackgroundImage(UIImage(systemName: "questionmark.square.dashed"), for: UIControl.State())
                }
                let pindropColor = thisAnnotation.color
                if let _ = thisAnnotation.importance {
                    switch thisAnnotation.importance! {
                    case 0:
                        thisAnnotation.color = .red
                    case 1:
                        thisAnnotation.color = .orange
                    case 2:
                        thisAnnotation.color = .yellow
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
                if (notification.state == true) {
                    let pin = NotificationAnnotation(title: notification.notifName, subtitle: notification.identity, coordinate: CLLocationCoordinate2D(latitude: notification.reportedLocationLat, longitude: notification.reportedLocationLong), color: (notification.importance == 0) ? UIColor.red : UIColor.yellow, pinDropID: notification.pinDropId, importance: notification.importance)
                    
                    notificationAnnotations.append(pin)
                }
        }
        mapView.reloadInputViews() //reload data
        mapView.addAnnotations(notificationAnnotations)
    }
    
    
    @objc
    func profilesReceived() {
        profileAnnotations.removeAll()
        
        mapView.removeAnnotations(mapView.annotations)
        
        for profile in profileService.profiles {
            let profilePin = ProfileAnnotation(profileID: profile.userID, coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            
            profileAnnotations.append(profilePin)
        }
        
        mapView.reloadInputViews()
        mapView.addAnnotations(profileAnnotations)
        
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
                print("reporter email (user id): ")
                print(dvc.selectedItem!.userID)
                print("pindrop id: ")
                print(selectedNotificationAnnotation!.pinDropID)
                
                dvc.selectedProfileID = dvc.selectedItem!.userID
            }
        }
        
//        if selectedProfileAnnotation != nil {
//            if(segue.identifier == "notificationSegue") {
//                let dvc = segue.destination as! PinDropDetailViewController
//
//
//
//                //need to add profile info here
//                dvc.selectedIncidentProfile = profileService.getProfileInfo(userID: selectedProfileAnnotation!.profileID)
//                print("reporter profile id: ")
//                print(dvc.selectedIncidentProfile!.userID)
//            }
//        }
       
    }
}
