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
        let viewModel = LoginViewModel(service: ApiServiceFactory.create())
       
        guard let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController", creator: { coder in
            return LoginViewController(coder: coder, viewModel: viewModel)
        }) as? LoginViewController else {
            fatalError("Failed to load EditUserViewController from storyboard.")
        }
        
        loginViewController.modalPresentationStyle = .fullScreen
        show(loginViewController, sender: nil)
    }
    
}

