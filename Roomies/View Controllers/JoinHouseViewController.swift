//
//  JoinHouseViewController.swift
//  Roomies
//
//  Created by edan yachdav on 5/15/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class JoinHouseViewController: UIViewController {

    @IBOutlet weak var houseIdTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func joinTapped(_ sender: Any) {
        if let houseId = houseIdTextField.text {
            FirebaseManager.instance.joinHouse(with: houseId, completion: {() in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
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
