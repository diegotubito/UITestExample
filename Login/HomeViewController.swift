//
//  ViewController.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import UIKit

class HomeViewController: UIViewController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        loginViewController.modalPresentationStyle = .overFullScreen
        show(loginViewController, sender: nil)
    }
    
}
