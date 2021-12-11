//
//  Coordinator.swift
//  Login
//
//  Created by David Diego Gomez on 11/12/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var children: [Coordinator]? { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

protocol Storyboarded {
    static func instatiate(name: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instatiate(name: String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        let identifier = String(describing: self)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self
        return vc!
    }
  
}


/*
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
 */
