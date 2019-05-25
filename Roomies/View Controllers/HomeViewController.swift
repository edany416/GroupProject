//
//  HomeViewController.swift
//  Roomies
//
//  Created by edan yachdav on 5/6/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var addButton: UIView!
    private var labelRef: UILabel?
    
    private var itemList: [ListItem]?
    
    
    
    var newItemName: String? {
        willSet(newItem) {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd HH:mm:ss"
            let dateString = dateFormatter.string(from: currentDate)
            
            let userName = "\(FirebaseManager.instance.firstName) \(FirebaseManager.instance.lastName)"
            let item = ListItem(name: newItem!, addedBy: userName, timeAdded: dateString)
            itemList?.append(item)
            tableView.reloadData()
            
            if FirebaseManager.instance.userBelongsToHouse {
                DBManager.instance.REF_LISTS.updateChildValues(["/\(FirebaseManager.instance.houseID)/items/\(newItem!)": ["name":newItem!, "addedBy":userName, "timeAdded":dateString]])
            }
            
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
        let label = UILabel(frame: rect)
        label.numberOfLines = 0
        label.textAlignment = .center
        //label.textColor = UIColor.lightText
        label.text = "Create or join a house to get started"
        label.center = CGPoint(x: x, y: y)
        self.view.addSubview(label)
        
        labelRef = label
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addItemViewTapped))
        addItemView.addGestureRecognizer(tapGesture)
        
        if FirebaseManager.instance.userBelongsToHouse {
            self.itemList = FirebaseManager.instance.productList
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
        if FirebaseManager.instance.userBelongsToHouse && !FirebaseManager.instance.isObserving {
            attachObserver()
        } else {
            if !FirebaseManager.instance.userBelongsToHouse && itemList != nil {
                itemList = nil
            }
            tableView.reloadData()
        }
    }
    
    private func updateLayout() {
        if !FirebaseManager.instance.userBelongsToHouse {
            tableView.isHidden = true
            addButton.isHidden = true
            labelRef!.isHidden = false
        } else {
            tableView.isHidden = false
            addButton.isHidden = false
            labelRef!.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList != nil {
            if itemList?.count == 0 {
                tableView.separatorStyle = .none
            } else {
                tableView.separatorStyle = .singleLine
            }
            return itemList!.count
        }
        
        tableView.separatorStyle = .none
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        let item = itemList![indexPath.row]
        
        cell.itemName.text = item.name
        cell.addedBy.text = "Added by: \(item.addedBy) "
        
        cell.delegate = self

        return cell
    }
    
    func didTapCheckBox(for cell: ItemCell) {
        cell.delegate = nil
        let indexPath = tableView.indexPath(for: cell)
        
        itemList?.remove(at: indexPath!.row)
        
        tableView.reloadData()
        DBManager.instance.REF_LISTS.child("/\(FirebaseManager.instance.houseID)/items/\(cell.itemName.text!)").removeValue()
    }
    
    @objc private func addItemViewTapped() {
        let addItemController = AddItemController()
        addItemController.presetAlert(from: self)
    }
    
    func sortsItemsByTime(this: ListItem, that: ListItem) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd HH:mm:ss"
        
        let firstTime = dateFormatter.date(from: this.timeAdded) as! Date
        let secondTime = dateFormatter.date(from: that.timeAdded) as! Date
        
        return firstTime < secondTime
    }
    
    private func attachObserver() {
        DBManager.instance.REF_LISTS.child(FirebaseManager.instance.houseID).child("items").observe(.value, with: {(snapshot) -> Void in
            print("observer call back called")
            let data = snapshot.value as? [String : Any] ?? [:]
            
            if data.isEmpty {
                self.itemList = [ListItem]()
            } else {
                self.itemList = [ListItem]()
                
                for (_ , value) in data {
                    let item = value as! [String : String]
                    let listItem = ListItem(name: item["name"]!, addedBy: item["addedBy"]!, timeAdded: item["timeAdded"]!)
                    self.itemList?.append(listItem)
                }
                self.itemList?.sort(by: self.sortsItemsByTime)
            }
            self.tableView.reloadData()
        })
        FirebaseManager.instance.isObserving = true
    }    
}
