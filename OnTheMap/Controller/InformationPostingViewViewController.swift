//
//  InformationPostingViewViewController.swift
//  OnTheMap
//
//  Created by Fatima Aljaber on 05/01/2019.
//  Copyright © 2019 Fatima. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewViewController: UIViewController {

    var api = API()
    @IBOutlet var location: UITextField!
    @IBOutlet var URL: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        api.gettingUserData(userKey: User.UserInfo.key!)

    }




    @IBAction func findLocation(_ sender: Any) {
        if (self.location.text == "" && self.URL.text == ""){
            alert(message: "Enter your location and URL")
        }
        else {
            
        
        let geocoder = CLGeocoder()
        let address = self.location.text
            geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                self.alert(message: "The error is \(error!)")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                let iteminfo = self.storyboard?.instantiateViewController(withIdentifier: "mapViewV") as! MapViewController
                iteminfo.latitude = coordinates.latitude
                iteminfo.longitude = coordinates.longitude
                iteminfo.URL = self.URL.text
                iteminfo.mapString = address
                self.navigationController?.pushViewController(iteminfo, animated: true)
            }
        })
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
