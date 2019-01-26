//
//  ViewController.swift
//  PinSample
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

/**
* This view controller demonstrates the objects involved in displaying pins on a map.
*
* The map is a MKMapView.
* The pins are represented by MKPointAnnotation instances.
*
* The view controller conforms to the MKMapViewDelegate so that it can receive a method 
* invocation when a pin annotation is tapped. It accomplishes this using two delegate 
* methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

class ViewController: UIViewController, MKMapViewDelegate {
    
    var api = API()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async() {
            self.mapNetworking()
        }
        }

    override func viewDidAppear(_ animated: Bool) {
        mapNetworking()
    }
    @IBAction func reload(_ sender: UIBarButtonItem) {
        mapNetworking()
    }
    @IBAction func Logout(_ sender: Any) {
        api.deletingasession()

        self.tabBarController?.dismiss(animated: true, completion: nil)

    }
    func alert(message:String){
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "OOPS", message:"\(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
    }
    func mapNetworking(){
        
        api.getDataOfStudent { (locationa,Error)  in
            if (Error.isEmpty){
            var annotations = [MKPointAnnotation]()
            if (locationa.firstName != nil && locationa.lastName != nil && locationa.latitude != nil && locationa.longitude != nil && locationa.mediaURL != nil ){
                let lat = CLLocationDegrees(locationa.latitude)
                let long = CLLocationDegrees(locationa.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(locationa.firstName!) \(locationa.lastName!)"
                annotation.subtitle = locationa.mediaURL
                annotations.append(annotation)

                }
            self.mapView.addAnnotations(annotations)

            }
            else{
                self.alert(message: Error)
            }
            
        }
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
//    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        
//        if control == annotationView.rightCalloutAccessoryView {
//            let app = UIApplication.sharedApplication()
//            app.openURL(NSURL(string: annotationView.annotation.subtitle))
//        }
//    }


    
}
