//
//  OnDutyViewController.swift
//  MUPD-SOS
//
//  Created by Kinneret Kanik on 05/03/2023.
//

import UIKit

class OnDutyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    //connect to our service files
    let userService = UserService.shared
    let mupdprofileService = MUPDProfileService.shared
    
    var mupdprofiles: [MUPDProfile] = [] //njCountiesSorted or shapeList
    var filteredMUPDProfiles: [MUPDProfile] = []
    let searchController = UISearchController()
    
    @IBOutlet var ondutytableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
        ondutytableView.delegate = self
        ondutytableView.dataSource = self
    }
    
    func initSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "On Duty", "Off Duty"]
        searchController.searchBar.delegate = self
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
            let mupdprofile = MUPDProfile(userID: mupdprofile.userID, title: mupdprofile.title, fullName: mupdprofile.fullName, badge: mupdprofile.badge, onDuty: mupdprofile.onDuty)
            
            mupdprofiles.append(mupdprofile)
        }
        
        ondutytableView.reloadData()
        print("this is all mupdProfiles:" )
        print(mupdprofiles)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchController.isActive) {
            return filteredMUPDProfiles.count
        }
        
        return mupdprofiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mupdprofileCell", for: indexPath)
        
        var thisMUPDProfile = mupdprofiles[indexPath.row]
        
        if(searchController.isActive) {
            thisMUPDProfile = filteredMUPDProfiles[indexPath.row]
        } else {
            thisMUPDProfile = mupdprofiles[indexPath.row]
        }
        
        cell.textLabel?.text = thisMUPDProfile.fullName
        cell.detailTextLabel?.text = thisMUPDProfile.onDuty
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton : String = "All")
    {
        filteredMUPDProfiles = mupdprofiles.filter
        {
            duty in
            let scopeMatch = (scopeButton == "All" || duty.onDuty.lowercased().contains(scopeButton.lowercased()))
            if(searchController.searchBar.text != "")
            {
                let searchTextMatch = duty.onDuty.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            }
            else
            {
                return scopeMatch
            }

        }
        ondutytableView.reloadData()
    }

}
