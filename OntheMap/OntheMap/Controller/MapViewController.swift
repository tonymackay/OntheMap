//
//  MapViewController.swift
//  OntheMap
//
//  Created by Tony Mackay on 28/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    let reuseIdentifier: String = "Pin"
    let loginIdentifier = "LoginViewController"
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        _ = OTMClient.getStudentLocations() { locations, error in
            if let error = error {
                print(error.localizedDescription)
            }

            OTMModel.studentLocations = locations
            self.refreshMap()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayLogin()
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
        displayLogin()
    }
    
    func refreshMap() {
        var annotations = [MKPointAnnotation]()
        for location in OTMModel.studentLocations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: ((view.annotation?.subtitle) ?? "") ?? "") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func displayLogin() {
        if !OTMModel.isAuthenticated {
            let loginVC = storyboard?.instantiateViewController(withIdentifier: loginIdentifier) as! LoginViewController
            
            loginVC.modalPresentationStyle = .fullScreen
            
            present(loginVC, animated: true, completion: nil)
        }
    }
}
