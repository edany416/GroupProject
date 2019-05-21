//
//  FirebaseManager.swift
//  Roomies
//
//  Created by edan yachdav on 5/15/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct Constants {
    static let firstMember = 1
}

private struct UserBasedInfo {
    var firstName: String
    var lastName: String
    var houseID: String
}

struct HouseBasedInfo {
    var products: [String]
}

class FirebaseManager {
    static let instance = FirebaseManager()
    
    private var houseBasedInfo: HouseBasedInfo?
    private var userBasedInfo: UserBasedInfo!
    
    var userIsLoggedIn: Bool {
        get { return Auth.auth().currentUser != nil }
    }
    var userBelongsToHouse: Bool {
        get { return houseBasedInfo != nil }
    }
    var productList: [String] {
        get { return houseBasedInfo!.products }
    }
    var houseID: String {
        get { return userBasedInfo.houseID }
    }
    var userID: String {
        get {return Auth.auth().currentUser!.uid}
    }
    var tempHouseID = ""
    var isObserving = false
    
    func createUser(withFirstName firstName: String, lastName: String, email: String, password: String, completion:@escaping (Bool) -> ()) {
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
                        DBManager.instance.createDBUser(uid: Auth.auth().currentUser!.uid, userData: ["first name": firstName, "last name": lastName, "email": email, "password": password, "houseID":""])
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
    
    func logIn(withEmail email: String, password: String, completion: @escaping (Bool)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                self.populateUserInfo(completion: {() in
                    completion(true)
                })
            } else {
                print("Error logging in \(error!.localizedDescription)")
                completion(false)
            }
        }
    }
    
    private func logoutTasks() {
        userBasedInfo = nil
        houseBasedInfo = nil
        isObserving = false
        DBManager.instance.REF_LISTS.removeAllObservers()
    }
    
    func logOut() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                logoutTasks()
                let main = UIStoryboard(name: "Main", bundle: nil)
                let logoViewController = main.instantiateViewController(withIdentifier: "LogoVC")
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = logoViewController
            } catch let error as NSError {
                print("Error logging out \(error.localizedDescription)")
            }
        }
    }
    
    func createHouse(completion: @escaping () -> ()) {
        let uuid = UUID().uuidString
        DBManager.instance.createDBHouse(houseID: uuid, houseData: ["listID": uuid, "chatID": uuid, "memberIDs":[FirebaseManager.instance.userID: FirebaseManager.instance.userID], "numMembers":Constants.firstMember])
        DBManager.instance.createDBList(listID: uuid, listData: [:])
        DBManager.instance.REF_USERS.child(FirebaseManager.instance.userID).updateChildValues(["houseID" : uuid])
        
        populateUserInfo(completion: { () in
            completion()
        })
    }
    
    func joinHouse(with id: String, completion: @escaping () -> ()) {
        DBManager.instance.REF_USERS.child(Auth.auth().currentUser!.uid).updateChildValues(["houseID" : id])
        
        populateUserInfo(completion: { () in
            DBManager.instance.REF_HOUSES.child(self.houseID).observeSingleEvent(of: .value, with: { (snapshot) in
                let data = snapshot.value as! NSDictionary
                let members = data["memberIDs"] as! NSMutableDictionary
                let numMembers = data["numMembers"] as! NSNumber
                members[Auth.auth().currentUser!.uid] = Auth.auth().currentUser!.uid
                let newNumMembers = numMembers.intValue + 1
                DBManager.instance.REF_HOUSES.child(self.houseID).child("memberIDs").setValue(members)
                DBManager.instance.REF_HOUSES.child(self.houseID).child("numMembers").setValue(newNumMembers)
                print(members)
                completion()
            })
        })
    }
    
    //function for leaving a house
    func leaveHouse(completion: @escaping () -> ()) {
        self.tempHouseID = self.houseID
        //remove user from house's member list
        DBManager.instance.REF_HOUSES.child(self.houseID).child("memberIDs").child(self.userID).removeValue()
        //update numMembers in firebase
        removeUserFromHouse(completion: { () in
            //update user's house to empty string in firebase
            DBManager.instance.REF_USERS.child(FirebaseManager.instance.userID).updateChildValues(["houseID" : ""])
            //reset user's info locally
            self.userBasedInfo = UserBasedInfo(firstName: self.userBasedInfo.firstName, lastName: self.userBasedInfo.lastName, houseID: "")
            self.houseBasedInfo = nil
            //remove observers
            DBManager.instance.REF_LISTS.removeAllObservers()
            self.isObserving = false
            completion()
        })
    }
    
    func removeUserFromHouse(completion: @escaping () -> ()) {
        DBManager.instance.REF_HOUSES.child(self.tempHouseID).observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as! NSDictionary
            let numMembers = data["numMembers"] as! NSNumber
            //if there are still members in the house, decrease numMembers
            if numMembers.intValue != Constants.firstMember {
                let newNumMembers = numMembers.intValue - 1
                DBManager.instance.REF_HOUSES.child(self.tempHouseID).child("numMembers").setValue(newNumMembers)
            }
                //otherwise, there are no more members so delete the house and the list
            else {
                DBManager.instance.REF_HOUSES.child(self.tempHouseID).removeValue()
                DBManager.instance.REF_LISTS.child(self.tempHouseID).removeValue()
            }
            completion()
        })
    }
    
    func populateUserInfo(completion: @escaping () -> ()) {
        populateBasicInfo(completion: { (isInHouse) in
            if isInHouse {
                self.populateHouseBasedInfo(completion: {() in
                    print("finished populating all info")
                    completion()
                })
            } else {
                completion()
            }
        })
    }
    
    private func populateBasicInfo(completion:@escaping (Bool)->()) {
        print("Populating user info")
        DBManager.instance.REF_USERS.child(FirebaseManager.instance.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let userData = snapshot.value as? NSDictionary
            let firstName = userData?["first name"] as? String ?? ""
            let lastName = userData?["last name"] as? String ?? ""
            let houseID = userData?["houseID"] as? String ?? ""

            self.userBasedInfo = UserBasedInfo(firstName: firstName, lastName: lastName, houseID: houseID)
            completion(!houseID.isEmpty)
        })
    }
    
    private func populateHouseBasedInfo(completion: @escaping ()->()) {
        print("Populating house info")
        DBManager.instance.REF_LISTS.child(userBasedInfo.houseID).observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? [String : Any] ?? [:]
            
            if data.isEmpty {
                self.houseBasedInfo = HouseBasedInfo(products: [String]())
            } else {
                var dataArray = [String]()
                let items = data["items"] as? [String: Any] ?? [:]
                for (_ , value) in items {
                    dataArray.append(value as! String)
                }
                self.houseBasedInfo = HouseBasedInfo(products: dataArray)
            }
            
//            if data["items"] is String {
//                self.houseBasedInfo = HouseBasedInfo(products: [String]())
//            } else {
//                let items = data["items"] as! NSDictionary
//                var dataArray = [String]()
//
//                for (_ , value) in items {
//                    dataArray.append(value as! String)
//                }
//                self.houseBasedInfo = HouseBasedInfo(products: dataArray)
//            }
            completion()
        })
    }
    
}
