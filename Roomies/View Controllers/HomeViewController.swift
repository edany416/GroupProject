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
    
    private var items = [String]()

    
    var newItemName: String? {
        willSet(newItem) {
            items.append(newItem!)
            DBManager.instance.REF_LISTS.child(UserServiceManager.houseID!).child("items").setValue(items)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if let items = UserServiceManager.shoppingItems {
            self.items = items
            tableView.reloadData()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addItemViewTapped))
        addItemView.addGestureRecognizer(tapGesture)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.itemName.text = items[indexPath.row]
        cell.delegate = self

        return cell
    }
    
    func didTapCheckBox(for cell: UITableViewCell) {
        print("check box was tapped")
    }
    
    @objc private func addItemViewTapped() {
        let addItemController = AddItemController()
        addItemController.presetAlert(from: self)
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
