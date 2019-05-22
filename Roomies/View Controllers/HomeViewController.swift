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
    //private var items: [String]?
    
    private var itemList: [ListItem]?
    
    
    
    var newItemName: String? {
        willSet(newItem) {
            //items!.append(newItem!)
            
            let userName = "\(FirebaseManager.instance.firstName) \(FirebaseManager.instance.lastName)"
            let item = ListItem(name: newItem!, addedBy: userName)
            itemList?.append(item)
            if FirebaseManager.instance.userBelongsToHouse {
                DBManager.instance.REF_LISTS.updateChildValues(["/\(FirebaseManager.instance.houseID)/items/\(newItem!)": ["name":newItem!, "addedBy":userName]])
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addItemViewTapped))
        addItemView.addGestureRecognizer(tapGesture)
        
        if FirebaseManager.instance.userBelongsToHouse {
            self.itemList = FirebaseManager.instance.productList
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FirebaseManager.instance.userBelongsToHouse && !FirebaseManager.instance.isObserving {
            attachObserver()
        } else {
            if !FirebaseManager.instance.userBelongsToHouse && itemList != nil {
                itemList = nil
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList != nil {
            return itemList!.count
        }
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
                    let listItem = ListItem(name: item["name"]!, addedBy: item["addedBy"]!)
                    self.itemList?.append(listItem)
                }
            }
            self.tableView.reloadData()
        })
        FirebaseManager.instance.isObserving = true
    }    
}
