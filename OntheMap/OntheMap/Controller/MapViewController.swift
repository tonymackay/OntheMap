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
    @IBOutlet weak var mapView: MKMapView!
    
    let reuseIdentifier: String = "Pin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        _ = OTMClient.getStudentLocations() { locations, error in
            if let error = error {
                print(error)
            }

            OTMModel.studentLocations = locations
            self.refreshMap()
        }
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
}
