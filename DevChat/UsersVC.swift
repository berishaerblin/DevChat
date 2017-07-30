//
//  UsersVC.swift
//  DevChat
//
//  Created by Erblin Berisha on 7/30/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    private var _snapData: Data?
    private var _videoURL: URL?
    
    
    var snapData: Data? {
        set{
            _snapData = newValue
        }
        get {
            return _snapData
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
        } get {
            return _videoURL
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.userRef.observeSingleEvent(of: .value, with: { [weak self](snapshot) in
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self?.users.append(user)
                            }
                        }
                    }
                }
            }
            self?.tableView.reloadData()
        })
        
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    

    
    @IBAction func sendPRBtnPressed(_ sender: Any) {
        if let url = _videoURL {
            let videoName = "\(NSUUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            let _ = ref.putFile(from: url, metadata: nil, completion: {[weak self] (meta, error) in
                if error != nil {
                    // do some error handling
                    print("Error uploading video \(String(describing: error?.localizedDescription))")
                } else {
                    let downloadURL = meta?.downloadURL()
                    DataService.instance.sendMediaPullRequest(senderUID: (Auth.auth().currentUser?.uid)!, sendingTo: (self?.selectedUsers)!, mediaURL: downloadURL!, textSnippet: "Coding today wa LEGIT")
                    //save this somewhere
                   
                }
            })
            self.dismiss(animated: true, completion: nil)
        } else if let snap = _snapData {
            let ref = DataService.instance.imagesStorageRef.child("\(NSUUID().uuidString).jpg")
            _ = ref.putData(snap, metadata: nil, completion: {[weak self] (meta, error) in
                if error != nil {
                    print("Error uploading snapshot: \(String(describing: error?.localizedDescription))")
                } else {
                    let downloadURL = meta?.downloadURL()
                    self?.dismiss(animated: true, completion: nil)
                    
                }
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    

}
