//
//  LogInViewController.swift
//  Roomies
//
//  Created by edan yachdav on 4/30/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SkyFloatingLabelTextField

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var logInButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        logInButton.backgroundColor = UIColor.clear
        
        var textFieldProps = SFTextFieldProps()
        textFieldProps.lineColor = UIColor.white
        textFieldProps.placeholderColor = UIColor.lightText
        textFieldProps.selectedLineColor = UIColor.white
        textFieldProps.selectedTitleColor = UIColor.white
        textFieldProps.textColor = UIColor.white
        textFieldProps.titleColor = UIColor.white
        
        textFieldProps.placeHolderText = "EMAIL"
        emailTextField.setProperties(props: textFieldProps)
        
        textFieldProps.placeHolderText = "PASSWORD"
        passwordTextField.setProperties(props: textFieldProps)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = UserServiceManager.currentUser {
            emailTextField.text = user.email
        }
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        UserServiceManager.signIn(withEmail: email, password: password) { (success) in
            if success {
                self.performSegue(withIdentifier: "Log In Successful Segue", sender: self)
            } else {
                print("Login unsuccessful")
                //Alert the user that there was a login error
            }
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
