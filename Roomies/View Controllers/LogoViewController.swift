//
//  LogoViewController.swift
//  Roomies
//
//  Created by Louise F Jensen on 4/30/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LogoViewController: UIViewController {

    @IBOutlet weak var logInButton: RoundedButton!
    @IBOutlet weak var signUpButton: RoundedButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.backgroundColor = UIColor.clear
        logInButton.backgroundColor = UIColor.white
        
        activityIndicator.type = .ballBeat
        activityIndicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseManager.instance.userIsLoggedIn {
            activityIndicator.startAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
