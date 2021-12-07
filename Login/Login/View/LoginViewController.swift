//
//  LoginViewController.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import UIKit


class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModelProtocol!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = LoginViewModel(withView: self, service: ApiService())
    }

    @IBAction func loginButtonDidTapped(_ sender: Any) {
        viewModel.login(userName: "diego", password: "david")
    }
    
    private func routeToHome() {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        loginViewController.modalPresentationStyle = .fullScreen
        show(loginViewController, sender: nil)
    }
}

extension LoginViewController: LoginViewProtocol {
    func showSuccess(dictionary: [String : Any]) {
        DispatchQueue.main.async {
            self.resultLabel.text = "success"
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.resultLabel.text = message
        }
    }
}
