//
//  LaunchCoordinator.swift
//  Login
//
//  Created by David Diego Gomez on 11/12/2021.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var children: [Coordinator]?
    
    var navigationController: UINavigationController
    
    func start() {
        let vc = HomeViewController.instatiate(name: "Main")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    init(navigationConstoller: UINavigationController) {
        self.navigationController = navigationConstoller
    }
    
    func routeToLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
}

