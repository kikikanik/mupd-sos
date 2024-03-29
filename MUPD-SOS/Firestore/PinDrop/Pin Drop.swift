//
//  Notification.swift
//  MUPD-SOS
//
import Foundation
import CoreLocation
import Firebase
import FirebaseFirestore

struct PinDrop {
    var userID: String       // Pulled from exisitng user from User collection
    var pinDropId: String
    var userCoordinateLat: Double
    var userCoordinateLong: Double
    var reportedLocationLat: Double
    var reportedLocationLong: Double
    var identity:String
    var acceptedNotif: Bool
    var importance: Int
    var notifName: String
    var state: Bool
    var submit: Bool
    var timestamp: String
    
    
    init(acceptedNotif: Bool, identity: String, importance: Int, userCoordinateLat: Double, pinDropId: String, userCoordinateLong: Double, reportedLocationLat: Double, reportedLocationLong: Double, notifName: String, state: Bool, submit: Bool, timestamp: String, userID: String) {
      
        self.userID = userID
        self.pinDropId = pinDropId
        self.identity = identity
        self.acceptedNotif = acceptedNotif
        self.importance = importance
        self.notifName = notifName
        self.state = state
        self.submit = submit
        self.timestamp = timestamp
        self.userCoordinateLat = userCoordinateLat
        self.userCoordinateLong = userCoordinateLong
        self.reportedLocationLat = reportedLocationLat
        self.reportedLocationLong = reportedLocationLong
    }

    init?(data: [String: Any], documentID: String) {
        guard let userID = data["userID"] as? String,
              let userCoordinateLat = data["userCoordinateLat"] as? Double,
              let userCoordinateLong = data["userCoordinateLong"] as? Double,
              let reportedLocationLat = data["reportedLocationLat"] as? Double,
              let reportedLocationLong = data["reportedLocationLong"] as? Double,
              let identity = data["identity"] as? String,
              let pinDropId = documentID as String?,
              let acceptedNotif = data["acceptedNotif"] as? Bool,
              let importance = data["importance"] as? Int,
              let notifName = data["notifName"] as? String,
              let state = data["state"] as? Bool,
              let submit = data["submit"] as? Bool,
              let timestamp = data["timestamp"] as? String else {
            return nil
        }
        self.userID = userID
        self.userCoordinateLat = userCoordinateLat
        self.userCoordinateLong = userCoordinateLong
        self.reportedLocationLat = reportedLocationLat
        self.reportedLocationLong = reportedLocationLong
        self.identity = identity
        self.acceptedNotif = acceptedNotif
        self.importance = importance
        self.notifName = notifName
        self.state = state
        self.submit = submit
        self.timestamp = timestamp
        self.pinDropId = pinDropId
    }
    
    func createPinDropDict() -> [String: Any]{
        let dict: [String: Any] = [
            "acceptedNotif": self.acceptedNotif,
            "identity": self.identity,
            "importance": self.importance,
            "userCoordinateLat": self.userCoordinateLat,
            "userCoordinateLong": self.userCoordinateLong,
            "reportedLocationLat": self.reportedLocationLat,
            "reportedLocationLong": self.reportedLocationLong,
            "notifName": self.notifName,
            "pinDropId": self.pinDropId,
            "state": self.state,
            "submit": self.submit,
            "userID": self.userID,
            "timestamp": self.timestamp
        ]
        return dict
    }
}
