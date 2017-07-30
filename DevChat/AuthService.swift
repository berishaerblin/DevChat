//
//  AuthService.swift
//  DevChat
//
//  Created by Erblin Berisha on 7/29/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (String?, AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                    if errorCode == AuthErrorCode.userNotFound {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self?.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                if user?.uid != nil {
                                    DataService.instance.saveUser(uid: user!.uid)
                                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            self?.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                        } else {
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    }
                } else {
                    // Handle all other errors
                    self?.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                }
            } else {
                // Successfully logged in
                onComplete?(nil, user)
            }
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .invalidEmail:
                onComplete?("Invalid email address", nil)
            case .wrongPassword:
                onComplete?("Invalid password", nil)
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
            default:
                onComplete?("There was a problem authenticating. Try agaig!", nil)
                
            }
        }
    }
}
