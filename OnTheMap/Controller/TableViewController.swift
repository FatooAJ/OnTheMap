//
//  TableViewController.swift
//  PinSample
//
//  Created by Fatima Aljaber on 05/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var api = API()
    var studentInfoArray = [StudentData]()

    @IBOutlet var Table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Table.dataSource = self
        Table.delegate = self

    }
    override func viewDidAppear(_ animated: Bool) {
        mapNetworking()
        self.Table.reloadData()
    }
    @IBAction func reload(_ sender: Any) {
        self.Table.reloadData()
        print(studentInfoArray.count)
    }
    @IBAction func Logout(_ sender: Any) {
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
                        self.studentInfoArray.append(studentinfo)
                    }}
        }
        self.Table.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfoArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell
        let Student = studentInfoArray[indexPath.row]
        cell.name!.text = "\(Student.firstName as! String )"+" "+"\(Student.lastName as! String)"
        cell.link?.text = Student.mediaURL

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let Student = studentInfoArray[indexPath.row].mediaURL

        if let url = URL(string: Student!)
        {
            UIApplication.shared.open(url)
        }
    }
}
