//
//  Notification Keys.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 20/02/2023.
//

import Foundation

let kSOSReportsChanged = "edu.monmouth.s1278692.sosReportsChanged"

let kSOSNotificaionsChanged = "edu.monmouth.s1278692.sosNotifiationsChanged"

let kSOSMUPDProfilesChanged = "edu.monmouth.s1278692.sosMUPDProfilesChanged"

let kSOSProfilesChanged = "edu.monmouth.s1278692.sosProfilesChanged"

let kSOSMessagesChanged = "edu.monmouth.s1278692.sosMessagesChanged"

extension Date {
    static func dateNTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmss"
        let tnow = dateFormatter.string(from: date)
        return tnow
    }
    
    static func dateNTimeLong(dt: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMddHHmmss"
        let tnow = dateFormatter.date(from: dt)
        let dateFormatter2 = DateFormatter()

        // Set Date/Time Style
        dateFormatter2.dateStyle = .medium
        dateFormatter2.timeStyle = .short

        // Convert Date to String
        return dateFormatter2.string(from: tnow!) // September 9, 2020 at 12:24 PM
    }

}
