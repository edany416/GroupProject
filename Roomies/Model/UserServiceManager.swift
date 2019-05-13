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

struct UserInfo {
    var firstName: String
    var lastName: String
    var houseID: String?
    var shoppingItems: [String]?
}

struct UserServiceManager {

    private static var userInfo: UserInfo?

    static func setHouseID(uuid: String) {
        userInfo?.houseID = uuid
    }
    
    
    static var currentUser: User? {
        get{
            return Auth.auth().currentUser
        }
    }
    
    static var userUID: String? {
        get {
            return currentUser?.uid
        }
    }
    
    static var firstName: String {
        get {
            return userInfo!.firstName
        }
    }
    
    static var lastName: String {
        get {
            return userInfo!.lastName
        }
    }
    
    static var houseID: String? {
        get {
            return userInfo?.houseID
        }
    }
    
    static var shoppingItems: [String]? {
        get {
            return userInfo?.shoppingItems
        }
    }
    
    static func populateUserInfo(finishedPopulating:@escaping (Bool) -> ()) {
        
        DBManager.instance.REF_USERS.child(UserServiceManager.userUID!).observeSingleEvent(of: .value) { (snapshot) in
            let userData = snapshot.value as? NSDictionary
            let firstName = userData?["first name"] as? String ?? ""
            let lastName = userData?["last name"] as? String ?? ""
            let houseID = userData?["houseID"] as? String ?? ""
            
            if houseID.isEmpty {
                self.userInfo = UserInfo(firstName: firstName, lastName: lastName, houseID: nil, shoppingItems: nil)
                finishedPopulating(true)
            } else {
                
                DBManager.instance.REF_LISTS.child(houseID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let data = snapshot.value as! NSDictionary
                    let items = data["items"] as! NSArray
                    self.userInfo = UserInfo(firstName: firstName, lastName: lastName, houseID: houseID, shoppingItems: items as? [String])
                    finishedPopulating(true)
                })
                
                
            }
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
                        DBManager.instance.createDBUser(uid: UserServiceManager.currentUser!.uid, userData: ["first name": firstName, "last name": lastName, "email": email, "password": password, "houseID":""])
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
                //TODO: Check for bugs
                self.populateUserInfo(finishedPopulating: { (true) in
                     completion(true)
                })
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
                userInfo = nil
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
