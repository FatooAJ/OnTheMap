//
//  StudentData.swift
//  OnTheMap
//
//  Created by Fatima Aljaber on 05/01/2019.
//  Copyright © 2019 Fatima. All rights reserved.
//

import Foundation

class StudentData{
    
    var createdAt : String!
    var firstName : String!
    var lastName : String!
    var latitude : Double!
    var longitude : Double!
    var mapString : String!
    var mediaURL : String!
    var objectId : String!
    var uniqueKey : String!
    var updatedAt : String!
    
    
    init (dictionary: NSDictionary) {
        self.createdAt = dictionary["createdAt"] as! String
        self.firstName = dictionary["firstName"] as! String
        self.lastName = dictionary["lastName"] as! String
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
        self.mapString = dictionary["mapString"] as! String
        self.mediaURL = dictionary["mediaURL"] as! String
        self.objectId = dictionary["objectId"] as! String
        self.uniqueKey = dictionary["uniqueKey"] as! String
        self.updatedAt = dictionary["updatedAt"] as! String
    }
    init () {
        self.createdAt = ""
        self.firstName = ""
        self.lastName = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.mapString = ""
        self.mediaURL = ""
        self.objectId = ""
        self.uniqueKey = ""
        self.updatedAt = ""
    }
    
}
