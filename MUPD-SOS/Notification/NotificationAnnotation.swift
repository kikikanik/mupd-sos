//
//  NotificationAnnotation.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation
import MapKit

class NotificationAnnotation: NSObject, MKAnnotation
{
    var title: String?
    
    var subtitle: String?
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var color: UIColor = .blue
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, color: UIColor) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.color = color
        }
}
