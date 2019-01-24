//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Fatima Aljaber on 06/01/2019.
//  Copyright © 2019 Fatima. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var latitude : Double!
    var longitude : Double!
    var URL: String!
    var mapString: String!
    var api = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        var annotations = [MKPointAnnotation]()

        let coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(User.UserInfo.firstname!) \(User.UserInfo.lastname!)"
        annotation.subtitle = self.URL
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        self.mapView.addAnnotations(annotations)

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

    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        let coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
    }
    @IBAction func Finish(_ sender: UIButton) {
        api.postingStudentLocation(mapString: self.mapString, MediaURL: self.URL, latitude: self.latitude, longitude: self.longitude) { (response, error) in
            if(response == false){
                self.alert(message: "The error is \(error)")
            }
            else{
                 DispatchQueue.main.async() {
                    self.navigationController?.popToRootViewController(true)
                    self.performSegue(withIdentifier: "table", sender: nil)}
            }
        }
        
    }
    
    func alert(message:String){
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "OPS", message:"\(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
    }


}
