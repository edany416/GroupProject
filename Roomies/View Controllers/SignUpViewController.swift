//
//  SignUpViewController.swift
//  Roomies
//
//  Created by Louise F Jensen on 4/30/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SkyFloatingLabelTextField
import NVActivityIndicatorView


class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var continueButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.backgroundColor = UIColor.white
        
        loadingIndicatorView.type = .ballBeat
        loadingIndicatorView.color = #colorLiteral(red: 0.3803921569, green: 0.1647058824, blue: 0.4235294118, alpha: 1)
        
        var textFieldProps = SFTextFieldProps()
        textFieldProps.lineColor = UIColor.white
        textFieldProps.placeholderColor = UIColor.lightText
        textFieldProps.selectedLineColor = UIColor.white
        textFieldProps.selectedTitleColor = UIColor.white
        textFieldProps.textColor = UIColor.white
        textFieldProps.titleColor = UIColor.white

        textFieldProps.placeHolderText = "FIRST NAME"
        firstNameTextField.setProperties(props: textFieldProps)

        textFieldProps.placeHolderText = "LAST NAME"
        lastNameTextField.setProperties(props: textFieldProps)

        textFieldProps.placeHolderText = "EMAIL"
        emailTextField.setProperties(props: textFieldProps)

        textFieldProps.placeHolderText = "PASSWORD"
        passwordTextField.setProperties(props: textFieldProps)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeybard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let continueButton = sender as? UIButton
        continueButton?.setTitle("", for: .normal)
        
        loadingIndicatorView.startAnimating()
                
        FirebaseManager.instance.createUser(withFirstName: firstName, lastName: lastName, email: email, password: password) { (success) in
            if success {
                self.loadingIndicatorView.stopAnimating()
                self.performSegue(withIdentifier: "SignUpSuccessfulSegue", sender: self)
            } else {
                print("Error creating user")
                self.loadingIndicatorView.stopAnimating()
                continueButton?.setTitle("Continue", for: .normal)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeybard() {
        view.endEditing(true)
    }
    
}
