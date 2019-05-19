//
//  SettingsViewController.swift
//  Roomies
//
//  Created by Louise on 5/9/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var houseIDLabel: UILabel!
    @IBOutlet weak var sendHouseIDButton: UIButton!
    @IBOutlet weak var settingsNavigationItem: UINavigationItem!
    @IBOutlet weak var logoutButton: RoundedButton!
    
    //userJustJoined {
    
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.backgroundColor = UIColor.red
        logoutButton.outlineColor = UIColor.red
        updateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func topButtonTapped(_ sender: Any) {
        if !FirebaseManager.instance.userBelongsToHouse { // User tapped to create a house
            FirebaseManager.instance.createHouse(completion: { () in
                self.updateLayout()
            })
        } else { // Code for leaving a house
            FirebaseManager.instance.leaveHouse(completion: { () in
                self.updateLayout()
            })
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        FirebaseManager.instance.logOut()
    }
    
    @IBAction func sendIDTapped(_ sender: Any) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = FirebaseManager.instance.houseID
        messageVC.recipients = ["Recipients"]
        messageVC.messageComposeDelegate = self
        
        self.present(messageVC, animated: true, completion: nil)
    }
    
    private func updateLayout() {
        if FirebaseManager.instance.userBelongsToHouse {
            topButton.setTitle("Leave house", for: .normal)
            bottomButton.isHidden = true
            houseIDLabel.isHidden = false
            houseIDLabel.text = "House ID:\n\(FirebaseManager.instance.houseID)"
            sendHouseIDButton.isHidden = false
        } else {
            topButton.setTitle("Create a house", for: .normal)
            bottomButton.isHidden = false
            bottomButton.setTitle("Join a house", for: .normal)
            houseIDLabel.isHidden = true
            sendHouseIDButton.isHidden = true
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
