//
//  ChatViewController.swift
//  Roomies
//
//  Created by Louise on 5/22/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageCellDelegate {

    @IBOutlet weak var addMessageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIView!
    
    private var label: UILabel?
    private var messageList: [MessageItem]?
    private var fullName = "\(FirebaseManager.instance.firstName) \(FirebaseManager.instance.lastName)"
    
    var newMessageText: String? {
        willSet(newMessage) {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd HH:mm:ss"
            let dateString = dateFormatter.string(from: currentDate)
            
//            print(dateString)
            
            let userName = "\(FirebaseManager.instance.firstName) \(FirebaseManager.instance.lastName)"
            let message = MessageItem(message: newMessage!, sentBy: userName, timeSent: dateString)
            messageList?.append(message)
            if FirebaseManager.instance.userBelongsToHouse {
                DBManager.instance.REF_CHATS.updateChildValues(["/\(FirebaseManager.instance.houseID)/chats/\(newMessage!)":["message":newMessage, "sentBy":userName, "timeSent":dateString]])
            }
            fullName = userName
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.dataSource = self
        tableView.delegate = self
        
        let x = self.view.bounds.midX
        let y = self.view.bounds.midY
        let width = 200
        let height = 100
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        label = UILabel(frame: rect)
        label!.numberOfLines = 0
        label!.textAlignment = .center
        //label.textColor = UIColor.lightText
        label!.text = "Go to settings and create or join a house to get started"
        label!.center = CGPoint(x: x, y: y)
        self.view.addSubview(label!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addMessageViewTapped))
        addMessageView.addGestureRecognizer(tapGesture)
        
        if FirebaseManager.instance.userBelongsToHouse {
            self.messageList = FirebaseManager.instance.chatList
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
        if FirebaseManager.instance.userBelongsToHouse && !FirebaseManager.instance.isObservingChat {
            attachObserver()
        } else {
            if !FirebaseManager.instance.userBelongsToHouse && messageList != nil {
                messageList = nil
            }
            tableView.reloadData()
        }
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messageList != nil {
            return messageList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        let messageItem = messageList![indexPath.row]
        
        cell.message.text = messageItem.message
        cell.sentBy.text = "\(messageItem.sentBy) at \(messageItem.timeSent)"
        
        if messageItem.sentBy == fullName {
            cell.message.textAlignment = .right
            cell.sentBy.textAlignment = .right
        } else {
            cell.message.textAlignment = .left
            cell.sentBy.textAlignment = .left
        }
        
        cell.delegate = self
        return cell
    }

    @objc private func addMessageViewTapped() {
        let addMessageController = AddMessageController()
        addMessageController.presetAlert(from: self)
    }
   
    func sortsMessagesByTime(this: MessageItem, that: MessageItem) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd HH:mm:ss"
        
        let firstTime = dateFormatter.date(from: this.timeSent) as! Date
        let secondTime = dateFormatter.date(from: that.timeSent) as! Date
        
        return firstTime < secondTime
    }
    
    private func updateLayout() {
        if !FirebaseManager.instance.userBelongsToHouse {
            tableView.isHidden = true
            addButton.isHidden = true
            label!.isHidden = false
        } else {
            tableView.isHidden = false
            addButton.isHidden = false
            label!.isHidden = true
        }
    }
    
    private func attachObserver() {
        DBManager.instance.REF_CHATS.child(FirebaseManager.instance.houseID).child("chats").observe(.value, with: {(snapshot) -> Void in
            print("observer call back called")
            let data = snapshot.value as? [String : Any] ?? [:]
            
            if data.isEmpty {
                self.messageList = [MessageItem]()
            } else {
                self.messageList = [MessageItem]()
                
                for (_ , value) in data {
                    let chat = value as! [String : String]
                    let messageItem = MessageItem(message: chat["message"]!, sentBy: chat["sentBy"]!, timeSent: chat["timeSent"]!)
                    self.messageList?.append(messageItem)
                }
                self.messageList?.sort(by: self.sortsMessagesByTime)
            }
            self.tableView.reloadData()
        })
        FirebaseManager.instance.isObservingChat = true
    }
    
}
