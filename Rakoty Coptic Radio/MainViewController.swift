//
//  ViewController.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit
import os.log

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        OSLog.rakoda.log(type: .info, "Hello from VC.")
        
        view.backgroundColor = .systemOrange
        navigationItem.title = "Rakoty"
        
    }


}

