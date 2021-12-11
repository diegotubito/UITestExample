//
//  ViewController.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    weak var coordinator: HomeCoordinator?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        coordinator?.routeToLoginFlow()
    }
    
}

