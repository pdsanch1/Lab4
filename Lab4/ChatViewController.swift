//
//  ChatViewController.swift
//  Lab4
//
//  Created by Pedro Daniel Sanchez on 10/3/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit
import Parse
class ChatViewController: UIViewController, UITableViewDataSource {
    
    var messages: [String] = []
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func onSendAction(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        // Note that below we assing a "PFUser" object so we
        // have to convert it back
        chatMessage["user"] = PFUser.current()
        print("** Username: \(PFUser.current()!.username! as String)")
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved")
                self.messageField.text=""
            } else {
                print("Saving error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 93
        tableView.dataSource = self
        
        queryMessages()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.getObjectInBackground(withId: "\(messages[indexPath.row])") {
            (message: PFObject?, error: Error?) -> Void in
            if error == nil && message != nil {
                cell.messageLabel.text = message?.value(forKey: "text") as? String
                if let user = message?["user"] as? PFUser {
                    let username1 = user.username!
                    cell.usernameLabel.text = "[by:  \(username1) ]"
                    //print("User = = = = = = > > \(username1)")
                } else {
                    cell.usernameLabel.text = "[ 🤖 ]"
                }
                //print("\(message?.value(forKey: "user") as? String)")
                //cell.usernameLabel.text = message?.value(forKey: "text") as? String
                //cell.username.text = message?.value(forKey: "user") as? String
            } else {
                print(error!)
            }
        }
        
        return cell
    }

    func queryMessages() {
        // Parse query and add message objects that have not been added
        let query = PFQuery(className:"Message")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects {          for message in objects {
                    // checks if message is already in array
                    if !(self.messages.contains(message.value(forKey: "objectId") as! String)) {
                        self.messages.insert(message.value(forKey: "objectId") as! String, at: 0)
                        self.tableView.reloadData()
                    }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }

    }
    @objc func onTimer() {
        queryMessages()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
