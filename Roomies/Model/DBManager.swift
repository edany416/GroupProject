//
//  DBManager.swift
//  Roomies
//
//  Created by Louise on 5/7/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import Foundation
import Firebase


let DB_ROOT = Database.database().reference()

class DBManager {
    
    static let instance = DBManager()
    
    private var _REF_ROOT = DB_ROOT
    private var _REF_HOUSES = DB_ROOT.child("houses")
    private var _REF_USERS = DB_ROOT.child("users")
    private var _REF_LISTS = DB_ROOT.child("lists")
    private var _REF_CHATS = DB_ROOT.child("chats")
    
    var REF_HOUSES: DatabaseReference {
        return _REF_HOUSES
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_LISTS: DatabaseReference {
        return _REF_LISTS
    }
    
    var REF_CHATS: DatabaseReference {
        return _REF_CHATS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func createDBHouse(houseID: String, houseData: Dictionary<String, Any>) {
        REF_HOUSES.child(houseID).updateChildValues(houseData)
    }
    
    func createDBList(listID: String, listData: Dictionary<String, Any>) {
        DBManager.instance.REF_LISTS.updateChildValues(["/\(listID)/items": "items"])
    }
    
    func createDBChat(chatID: String, chatData: Dictionary<String, Any>) {
        DBManager.instance.REF_CHATS.updateChildValues(["/\(chatID)/chats": "chats"])
    }
}
