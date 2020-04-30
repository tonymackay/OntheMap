//
//  LocationsViewController.swift
//  OntheMap
//
//  Created by Tony Mackay on 27/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit

class LocationsViewController: UITableViewController {
    
    // MARK: Outlets
    
    let reuseIdentifier: String = "LocationTableViewCell"
    let loginIdentifier = "loginSegue"
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMModel.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        let location = OTMModel.studentLocations[indexPath.row]
        
        cell.textLabel?.text = location.firstName + " " + location.lastName
        cell.detailTextLabel?.text = location.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = OTMModel.studentLocations[indexPath.row]
        
        guard let url = URL(string: location.mediaURL) else { return }
        UIApplication.shared.open(url)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func logoutTapped(_ sender: Any) {
        OTMClient.logout(completion: handleLogout(success:error:))
    }
    
    // MARK: Private Methods
    
    func handleLogout(success: Bool, error: Error?) {
        if (success) {
            print("Logout Success")
        } else {
            print(error ?? "")
        }
        OTMModel.isAuthenticated = false
        dismiss(animated: true, completion: nil)
    }
}
