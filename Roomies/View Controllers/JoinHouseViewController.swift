//
//  JoinHouseViewController.swift
//  Roomies
//
//  Created by edan yachdav on 5/15/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class JoinHouseViewController: UIViewController {

    @IBOutlet weak var houseIdTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var joinButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinButton.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.1647058824, blue: 0.4235294118, alpha: 1)
        joinButton.outlineColor = #colorLiteral(red: 0.3803921569, green: 0.1647058824, blue: 0.4235294118, alpha: 1)
        
        
        var textFieldProps = SFTextFieldProps()
        textFieldProps.lineColor = #colorLiteral(red: 0.3803921569, green: 0.1647058824, blue: 0.4235294118, alpha: 1)
        textFieldProps.placeholderColor = UIColor.gray
        textFieldProps.selectedLineColor = #colorLiteral(red: 0.3803921569, green: 0.1647058824, blue: 0.4235294118, alpha: 1)
        textFieldProps.selectedTitleColor = UIColor.black
        textFieldProps.textColor = UIColor.black
        textFieldProps.titleColor = UIColor.black
        
        textFieldProps.placeHolderText = "HOUSE ID"
        houseIdTextField.setProperties(props: textFieldProps)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeybard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    @IBAction func joinTapped(_ sender: Any) {
        if let houseId = houseIdTextField.text {
            FirebaseManager.instance.joinHouse(with: houseId, completion: {() in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc private func dismissKeybard() {
        view.endEditing(true)
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
