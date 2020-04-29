//
//  AddLocationViewController.swift
//  OntheMap
//
//  Created by Tony Mackay on 29/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    let addLocationMapIdentifier = "AddLocationMapViewController"
    let geocoder = CLGeocoder()
    
    // MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    
    @IBAction func cancelTapped(_ sender: Any) {
        
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        guard let address = locationTextField.text else {
            return
        }
        
        if !linkIsValid(link: linkTextField.text) {
            displayError(message: "Invalid URL")
        }
        
        setLocating(true)
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    func setLocating(_ locating: Bool) {
        if locating {
            //activityIndicator.startAnimating()
        } else {
            //activityIndicator.stopAnimating()
        }
        locationTextField.isEnabled = !locating
        linkTextField.isEnabled = !locating
        findLocationButton.isEnabled = !locating
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        setLocating(false)

        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            displayError(message: "Unable to Find Location for Address")

        } else {
            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                showMap(coordinate: location.coordinate)
            } else {
               displayError(message: "No Matching Location Found")
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

        let mapVC = storyboard?.instantiateViewController(withIdentifier: addLocationMapIdentifier) as! AddLocationMapViewController
        
        mapVC.location = location
        mapVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func displayError(message: String) {
        let alertVC = UIAlertController(title: "Add Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }
}
