//
//  AddLocationMapViewController.swift
//  OntheMap
//
//  Created by Tony Mackay on 29/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: Variables
    
    var location: Location?
    let reuseIdentifier: String = "Pin"
    let segueId: String = "finishSegue"

    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let location = location {
            print("View Appeard with: \(location)")
            showLocationOnMap(location: location)
        }
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
    
    @IBAction func cancelTapped(_ sender: Any) {
        performSegue(withIdentifier: segueId, sender: nil)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        guard let location = location else { return }
        
        OTMClient.addLocation(address: location.address, link: location.link, latitude: location.latitude, longitude: location.longitude, completion: handleResponse(success:error:))
    }
    
    // MARK: Methods
    
    func handleResponse(success: Bool, error: Error?) {
        if success {
            print("success")
            performSegue(withIdentifier: segueId, sender: nil)
        } else {
            if let error = error {
                showAlert(title: "Failed to Add Location", message: error.localizedDescription)
            }
        }
    }
    
    func showLocationOnMap(location: Location) {
        mapView.removeAnnotations(mapView.annotations)

        let lat = CLLocationDegrees(location.latitude)
        let long = CLLocationDegrees(location.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(location.address)"
        annotation.subtitle = location.link
    
        mapView.addAnnotation(annotation)
        
        // zoom to user location
        let regionRadius: CLLocationDistance = 10000
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(viewRegion, animated: false)
    }
}
