//
//  ProfileAnnotation.swift
//  MUPD-SOS
//

import Foundation
import MapKit

class ProfileAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var profileID: String
    
    init(profileID: String, coordinate: CLLocationCoordinate2D) {
        self.profileID = profileID
        self.coordinate = coordinate
    }
    
}
