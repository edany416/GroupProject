//
//  SettingsViewController.swift
//  Roomies
//
//  Created by Louise on 5/9/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var houseIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonTitle()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func topButtonTapped(_ sender: Any) {
        //If user is not part of a house then...
        let uuid = UUID().uuidString
        DBManager.instance.createDBHouse(houseID: uuid, houseData: ["listID": "", "chatID": "", "memberIDs": FirebaseAPIManager.currentUser!.uid])
        DBManager.instance.REF_USERS.child(FirebaseAPIManager.currentUser!.uid).updateChildValues(["houseID" : uuid])
        setButtonTitle()
    }
    
  
    @IBAction func bottomButtonTapped(_ sender: Any) {
    }
    
    @IBAction func onLogout(_ sender: Any) {
        FirebaseAPIManager.signOut()
    }
    
    func setButtonTitle() {
        DBManager.instance.REF_USERS.child(FirebaseAPIManager.currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let userData = snapshot.value as? NSDictionary
            let houseID = userData?["houseID"] as? String ?? ""
            
            if houseID.isEmpty {
                self.topButton.setTitle("Create", for: .normal)
                self.bottomButton.setTitle("Join", for: .normal)
                self.houseIDLabel.isHidden = true
            }
            else {
                self.topButton.setTitle("Create", for: .normal)
                self.bottomButton.setTitle("Leave", for: .normal)
                self.topButton.isEnabled = !self.topButton.isEnabled
                self.houseIDLabel.isHidden = false
                self.houseIDLabel.text = "House ID:\n\(houseID)"
            }
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
