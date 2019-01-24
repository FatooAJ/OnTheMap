//
//  TableViewController.swift
//  PinSample
//
//  Created by Fatima Aljaber on 05/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
class TableViewController: UITableViewController {
    
    var api = API()

    var Student = StudentData()
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapNetworking()
        table.reloadData()
    }
    @IBAction func reload(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            table.reloadData()
        }
        else
        {
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            controller.addAction(ok)
            controller.addAction(cancel)
            
            present(controller, animated: true, completion: nil)
        }
        
    }
    @IBAction func logout(_ sender: Any) {
        api.deletingasession()
        DispatchQueue.main.async() {
            self.performSegue(withIdentifier: "Login", sender: self)
        }
    }
    
    func mapNetworking(){
        
        api.getDataOfStudent { (locations) in
            for dictionary in locations {
                    if dictionary["firstName"] != nil && dictionary["lastName"] != nil && dictionary["mediaURL"] != nil {
                        let studentinfo = StudentData(dictionary: dictionary as NSDictionary)
                        self.Student.addStudent(studentinfo: studentinfo)
                    }}
        }
        table.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Student.studentInfoArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell
        let StudentCell = Student.studentInfoArray[indexPath.row]
        
        cell.name!.text = "\(StudentCell.firstName as! String )"+" "+"\(StudentCell.lastName as! String)"
        cell.link?.text = StudentCell.mediaURL

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let Studentcell = Student.studentInfoArray[indexPath.row].mediaURL

        if let url = URL(string: Studentcell!)
        {
            UIApplication.shared.open(url)
        }
    }
    public class Reachability {
        class func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            let isReachable = flags == .reachable
            let needsConnection = flags == .connectionRequired
            return isReachable && !needsConnection
        }
    }
}
