//
//  AddLocationViewController.swift
//  OntheMap
//
//  Created by Tony Mackay on 29/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    let segueId = "addLocationMapSegue"
    let geocoder = CLGeocoder()
    
    // MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue called: \(segue.identifier ?? "")")
        if segue.identifier == segueId {
            let addLocationMapVC = segue.destination as! AddLocationMapViewController
            let location = sender as! Location
            addLocationMapVC.location = location
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == locationTextField {
            textField.resignFirstResponder()
            linkTextField.becomeFirstResponder()
        } else if textField == linkTextField {
            textField.resignFirstResponder()
            locate()
        }
        return true
    }
    
    // MARK: Actions
    
    @IBAction func findLocationTapped(_ sender: Any) {
        locate()
    }
    
    // MARK: Methods
    
    func locate() {
        guard let address = locationTextField.text else {
            return
        }
        
        if !linkIsValid(link: linkTextField.text) {
            showAlert(title: "Add Location Failed", message: "Invalid URL")
        }
        
        setLocating(true)
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    func setLocating(_ locating: Bool) {
        if locating {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
        locationTextField.isEnabled = !locating
        linkTextField.isEnabled = !locating
        findLocationButton.isEnabled = !locating
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        setLocating(false)

        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            showAlert(title: "Add Location Failed", message: "Unable to Find Location for Address")

        } else {
            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                showMap(coordinate: location.coordinate)
            } else {
               showAlert(title: "Add Location Failed", message: "No Matching Location Found")
            }
        }
    }
    
    func linkIsValid(link: String?) -> Bool {
        guard let link = link,
              let url = URL(string: link) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func showMap(coordinate: CLLocationCoordinate2D) {
        print( "LAT: \(coordinate.latitude), LONG: \(coordinate.longitude)" )
        
        guard let address = locationTextField.text else { return }
        guard let link = linkTextField.text else { return }

        let location = Location(address: address, link: link, latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        performSegue(withIdentifier: segueId, sender: location)
    }
}
