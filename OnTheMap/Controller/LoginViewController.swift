//
//  LoginViewController.swift
//  PinSample
//
//  Created by Fatima Aljaber on 04/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    var api = API()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logIn(_ sender: UIButton) {
        let emailtext = email.text
        let passtext = password.text
        if (emailtext != nil && passtext != nil){
            api.login(username: emailtext, password: passtext) { (JSON, errormessage) in
                if(errormessage != ""){
                    self.alert(message: errormessage)
                }
                else{
                    if (JSON != "false"){
                        print(JSON)
                    User.UserInfo.key = JSON
                    DispatchQueue.main.async() {
                        self.performSegue(withIdentifier: "ToMap", sender: self)
                        }}
                    else{
                        self.alert(message: errormessage)
                    }

                }
            }
        
        }}
    
    func alert(message:String){
        DispatchQueue.main.async() {
        let alert = UIAlertController(title: "OOPS", message:"\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
            return
            
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let url = NSURL(string: "https://auth.udacity.com/sign-up")!
        UIApplication.shared.openURL(url as URL)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }


}
