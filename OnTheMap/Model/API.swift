//
//  API.swift
//  OnTheMap
//
//  Created by Fatima Aljaber on 05/01/2019.
//  Copyright © 2019 Fatima. All rights reserved.
//

import Foundation
class API {
    
    
    func login (username : String!,password : String!, completion: @escaping (String, String)->()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            func displayError(_ error: String) {
                completion("",error)
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode! >= 200  && statusCode! < 300 {
                            do{
                                let range = Range(5..<data.count)
                                let newData = data.subdata(in: range) /* subset response data! */
                          //  print(String(data: newData!, encoding: .utf8)!)
                                let myJSON =  try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary
                                
                let accountDictionary = myJSON["account"] as? NSDictionary
                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                                completion (uniqueKey,"")}
                            catch let err {
                                completion ("", "The error is \(err)")
                }}
             else{
                completion ("false", "wrong email or password")
            }
        }
        
        task.resume()
    }
    var temp = [[String:Any]]()
    func getDataOfStudent(completion: @escaping ([[String : Any]])->()) {
        
        temp = [["":""]]
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func displayError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            do {
                
                let myJSON =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                //getting the JSON array result from the response
                let result = myJSON["results"] as! NSArray
                var ALLData: NSDictionary
                //looping through all the json objects in the array teams
                for i in 0..<result.count {
                    ALLData = result[i] as! NSDictionary
                    self.temp.append(ALLData as! [String:Any])
                    // print("-----------------------------------")
                }
                print(self.temp.count)
                completion(self.temp)
                //                print(Temp[0])
                //                print(Temp[1])
            } catch let err {
                completion([["err":err]])
            }
            // print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    func gettingUserData(userKey:String!){
        print("hhhhhhh\(userKey!)")
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(userKey!)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            let myJSON =  try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
            UserInfo.firstname = myJSON["first_name"] as! String
            UserInfo.lastname = myJSON["last_name"] as! String

            print(myJSON["first_name"] as! String)
            print(myJSON["last_name"] as! String)

        }
        task.resume()
    }
    func postingStudentLocation(mapString: String, MediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool,Error?)->()){
        print("{\"uniqueKey\": \"\(UserInfo.key!)\", \"firstName\": \"\(firstname!)\", \"lastName\": \"\(UserInfo.lastname!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(MediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}")
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UserInfo.key!)\", \"firstName\": \"\(UserInfo.firstname!)\", \"lastName\": \"\(UserInfo.lastname!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(MediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false,error)
            }
            else{
            completion(true,nil)
                print(String(data: data!, encoding: .utf8)!)}
        }
        task.resume()
    }
    func deletingasession(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
