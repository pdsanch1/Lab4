//
//  ViewController.swift
//  Lab4
//
//  Created by Pedro Daniel Sanchez on 10/3/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    var alertController: UIAlertController!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
 
    @IBAction func loginAction(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        if !((usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!) {
        
            PFUser.logInWithUsername(inBackground: username, password: password) { (user:PFUser?, error:Error?) in
                if user != nil { // same as if let user = user
                    print("login SUCCESSFUL !!")
                    print("Username: \(PFUser.current()!.username! as String)")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } 
            }
        } else {
            self.present(alertController, animated: true)
        }
    }
    @IBAction func signupAction(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        
        if !((usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!) {
            newUser.signUpInBackground { (success: Bool, error:Error?) -> Void in
                if success {
                    print("Yeeessss !, created a user")
                    //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else {
                    print(error?.localizedDescription as Any)
                    let err = error as NSError?
                    if err!.code == 202 {
                        print("username is taken")
                    }
                }
            }
        } else {
            self.present(alertController, animated: true)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        alertController = UIAlertController(title: "Error", message: "Please enter a username and password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)

    }


}

