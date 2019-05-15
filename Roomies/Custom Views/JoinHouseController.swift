//
//  JoinHouseController.swift
//  Roomies
//
//  Created by edan yachdav on 5/14/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class JoinHouseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presetAlert(from sourceVC: UIViewController) {
        let alertController = UIAlertController(title: "Join a House", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Join", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            (sourceVC as! SettingsViewController).houseID = firstTextField.text
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter House ID"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        sourceVC.present(alertController, animated: true, completion: nil)
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
