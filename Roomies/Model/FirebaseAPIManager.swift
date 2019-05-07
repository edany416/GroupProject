//
//  FirebaseAPIManager.swift
//  Roomies
//
//  Created by edan yachdav on 5/1/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct FirebaseAPIManager {
    
    static var currentUser: User? {
        get{
            return Auth.auth().currentUser
        }
    }
    
    static func createUser(withFirstName firstName: String, lastName: String, email: String, password: String, completion:@escaping (Bool) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                print("Error signing up \(error!.localizedDescription)")
                
                return
            } else {
                print("User successfully created")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = firstName + " " + lastName
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        print("User name successfully changed")
                        completion(true) // At this point VC will call perform segue
                    } else {
                        print("Error changing user name \(error!.localizedDescription)")
                        completion(false)
                        return
                    }
                })
            }
        }
    }
    
    static func signIn(withEmail email: String, password: String, completion: @escaping (Bool)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                completion(true)
            } else {
                print("Error logging in \(error!.localizedDescription)")
                completion(false)
            }
        }
    }
    
    static func signOut() {
        if currentUser != nil {
            do {
                try Auth.auth().signOut()
                let main = UIStoryboard(name: "Main", bundle: nil)
                let logoViewController = main.instantiateViewController(withIdentifier: "LogoVC")
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = logoViewController
                
            } catch let error as NSError {
                print("Error logging out \(error.localizedDescription)")
            }
        }
    }
}
