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
    var studentInfoArray = [StudentData]()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func mapNetworking(){
        api.getDataOfStudent { (locations) in
            
            // The "locations" array is an array of dictionary objects that are similar to the JSON
            // data that you can download from parse.
            // let locations = hardCodedLocationData()
            
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point annotations will be stored in this array, and then provided to the map view.
            var annotations = [MKPointAnnotation]()
            
            // The "locations" array is loaded with the sample data below. We are using the dictionaries
            // to create map annotations. This would be more stylish if the dictionaries were being
            // used to create custom structs. Perhaps StudentLocation structs.
            
            for dictionary in locations {
                print(dictionary)

                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                if dictionary["latitude"] != nil && dictionary["longitude"] != nil && dictionary["firstName"] != nil && dictionary["lastName"] != nil && dictionary["mediaURL"] != nil{
                    
                    let studentinfo = StudentData(dictionary: dictionary as NSDictionary)
                    
                    let lat = CLLocationDegrees(studentinfo.latitude)
                    let long = CLLocationDegrees(studentinfo.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(studentinfo.firstName) \(studentinfo.lastName)"
                        annotation.subtitle = studentinfo.mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        annotations.append(annotation)
                    }}
            
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
            
        }
    }
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
