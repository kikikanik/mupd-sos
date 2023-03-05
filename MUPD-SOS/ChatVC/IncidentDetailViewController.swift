//
//  IncidentDetailViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class IncidentDetailViewController: UIViewController {
    
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    let pindropService = PinDropService.shared

    var selectedIncident : PinDrop!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = selectedIncident.notifName
        
        // Make the VC delegate and datasource
        //reportList.dataSource = self
        //reportList.delegate = self
    }
}
