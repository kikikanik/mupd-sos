//
//  NotificationAnnotation.swift
//  MUPD-SOS
//

import Foundation
import MapKit

class NotificationAnnotation: NSObject, MKAnnotation
{
    var title: String?
    
    var subtitle: String?
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var color: UIColor
    
    var pinDropID: String
    
    var type = AnnotationTypes.notification
    
    var importance: Int?

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, color: UIColor, pinDropID: String, importance: Int) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.color = color
        self.pinDropID = pinDropID
        self.importance = importance
        }
}
