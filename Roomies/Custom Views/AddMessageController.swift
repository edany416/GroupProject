//
//  AddMessageController.swift
//  Roomies
//
//  Created by Louise on 5/22/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class AddMessageController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presetAlert(from sourceVC: UIViewController) {
        let alertController = UIAlertController(title: "Send New Message", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let sendAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            (sourceVC as! ChatViewController).newMessageText = firstTextField.text
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Message"
        }
        
        alertController.addAction(sendAction)
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

