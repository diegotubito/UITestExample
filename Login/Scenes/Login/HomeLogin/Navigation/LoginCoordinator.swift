//
//  Coordinator.swift
//  Login
//
//  Created by David Diego Gomez on 11/12/2021.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    var children: [Coordinator]?
    
    var navigationController: UINavigationController
    
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoginViewController.instatiate(name: "Login")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

