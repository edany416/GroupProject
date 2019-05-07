//
//  TestViewController.swift
//  Roomies
//
//  Created by edan yachdav on 5/6/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class TestViewController: UIViewController {

    @IBOutlet weak var aView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aView.type = .ballPulse
        // Do any additional setup after loading the view.
    }
    
    @IBAction func start(_ sender: Any) {
        aView.startAnimating()
    }
    
    @IBAction func stop(_ sender: Any) {
        aView.stopAnimating()
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
