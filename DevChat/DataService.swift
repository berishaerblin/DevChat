//
//  DataService.swift
//  DevChat
//
//  Created by Erblin Berisha on 7/30/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var userRef: DatabaseReference {
        return mainRef.child("users")
    }
    
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://devchat-e9a00.appspot.com")
    }
    
    var imagesStorageRef: StorageReference {
        return mainStorageRef.child("images")
    }
    
    var videoStorageRef: StorageReference {
        return mainStorageRef.child("videos")
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName" : "" as AnyObject, "lastName" : "" as AnyObject]
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo: Dictionary<String, User>, mediaURL: URL, textSnippet: String? = nil) {
        
        let pr: Dictionary<String, AnyObject> = ["mediaURL" : mediaURL.absoluteString as AnyObject, "userID" : senderUID as AnyObject, "openCount" : 0 as AnyObject, "recipients" : sendingTo.keys as AnyObject]
        
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
    }
    
}
