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
    private var items: [String]?
    
    var newItemName: String? {
        willSet(newItem) {
            items!.append(newItem!)
            
            guard let key = DBManager.instance.REF_LISTS.child(FirebaseManager.instance.houseID).childByAutoId().key else { return }
            DBManager.instance.REF_LISTS.updateChildValues(["/\(FirebaseManager.instance.houseID)/items/\(key)": newItem as Any])
            
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
            self.items = FirebaseManager.instance.productList
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FirebaseManager.instance.userBelongsToHouse && !FirebaseManager.instance.isObserving {
            attachObserver()
        }
        else {
            if items != nil {
                items = nil
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items != nil {
            return items!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.itemName.text = items![indexPath.row]
        cell.delegate = self

        return cell
    }
    
    func didTapCheckBox(for cell: UITableViewCell) {
        print("check box was tapped")
         DBManager.instance.REF_LISTS.up
        
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
                self.items = [String]()
            } else {
                self.items = [String]()
                for (_ , value) in data {
                    self.items!.append(value as! String)
                }
            }
            self.tableView.reloadData()
        })
        FirebaseManager.instance.isObserving = true
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
