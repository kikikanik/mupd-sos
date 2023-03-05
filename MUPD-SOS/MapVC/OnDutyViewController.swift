//
//  OnDutyViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class OnDutyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //connect to our service files
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    
    var mupdprofiles: [MUPDProfile] = [] //njCountiesSorted or shapeList
    
    @IBOutlet var ondutytableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ondutytableView.delegate = self
        ondutytableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(mupdProfilesReceived), name: Notification.Name(rawValue: kSOSMUPDProfilesChanged), object: nil)
        mupdprofileService.observeMUPDProfiles()
    }
    
    @objc
    func mupdProfilesReceived() {
        mupdprofiles.removeAll()
        for mupdprofile in mupdprofileService.MUPDProfiles {
            let mupdprofile = MUPDProfile(userID: userService.currentUser!.email, title: mupdprofile.title, fullName: mupdprofile.fullName, badge: mupdprofile.badge, onDuty: mupdprofile.onDuty)
            
            mupdprofiles.append(mupdprofile)
        }
        
        ondutytableView.reloadData()
        print("this is all mupdProfiles:" )
        print(mupdprofiles)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mupdprofiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mupdprofileCell", for: indexPath)
        
        let thisMUPDProfile = mupdprofiles[indexPath.row]
        
        cell.textLabel?.text = thisMUPDProfile.fullName
        cell.detailTextLabel?.text = thisMUPDProfile.onDuty
        
        return cell
    }

}
