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
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    
    let reuseIdentifier: String = "Pin"
    let loginIdentifier = "loginSegue"
    let addLocationIdentifier = "AddLocationViewController"
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        print("map view loaded")
        super.viewDidLoad()
        download()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
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
    
    // MARK: Actions
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func cancelWithRefresh(_ unwindSegue: UIStoryboardSegue) {
        download()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        OTMClient.logout(completion: handleLogout(success:error:))
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        print("refresh tapped")
        download()
    }
    
    // MARK: Private Methods
    
    func download() {
        setRefreshing(refreshing: true)
        _ = OTMClient.getStudentLocations() { locations, error in
            if let error = error {
                self.showAlert(title: "Download Failed", message: error.localizedDescription)
            }
            OTMModel.studentLocations = locations
            self.refreshMap()
            self.setRefreshing(refreshing: false)
        }
    }
    
    func handleLogout(success: Bool, error: Error?) {
        if (success) {
            print("Logout Success")
        } else {
            print(error ?? "")
        }
        OTMModel.isAuthenticated = false
        dismiss(animated: true, completion: nil)
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
    
    func setRefreshing(refreshing: Bool) {
        refreshButton.isEnabled = !refreshing
        logoutButton.isEnabled = !refreshing
        addLocationButton.isEnabled = !refreshing
    }
}
