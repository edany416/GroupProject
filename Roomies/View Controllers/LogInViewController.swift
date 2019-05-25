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
import NVActivityIndicatorView

class LogInViewController: UIViewController {

    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var logInButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        logInButton.backgroundColor = UIColor.white
        
        loadingIndicatorView.type = .ballBeat
        loadingIndicatorView.color = #colorLiteral(red: 0.3803921569, green: 0.1647058824, blue: 0.4235294118, alpha: 1)
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeybard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if FirebaseManager.instance.userIsLoggedIn {
            emailTextField.text = Auth.auth().currentUser?.email
        }
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let loginButton = sender as? UIButton
        loginButton?.setTitle("", for: .normal)
        
        
        loadingIndicatorView.startAnimating()
        
        FirebaseManager.instance.logIn(withEmail: email, password: password) { (success) in
            if success {
                self.performSegue(withIdentifier: "Log In Successful Segue", sender: self)
                self.loadingIndicatorView.stopAnimating()
            } else {
                self.loadingIndicatorView.stopAnimating()
                loginButton?.setTitle("Log in", for: .normal)
                print("Login unsuccessful")
            }
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeybard() {
        view.endEditing(true)
    }
}
