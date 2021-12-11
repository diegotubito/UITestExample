//
//  LoginViewController.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import UIKit

class LoginViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    weak var coordinator: LoginCoordinator?
    
    private var viewModel: LoginViewModelProtocol!

//    init?(coder: NSCoder, viewModel: LoginViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(coder: coder)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("You must create this view controller with a viewmodel.")
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = LoginViewModel(service: ApiServiceFactory.create())
        viewModelBind()
    }
    
    private func viewModelBind() {
        viewModel.onSuccess = { [weak self] user in
            DispatchQueue.main.async {
                self?.resultLabel.text = user.displayName
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.resultLabel.text = message
            }
        }
    }

    @IBAction func loginButtonDidTapped(_ sender: Any) {
        viewModel.login(userName: userName.text ?? "", password: password.text ?? "")
    }
    
    private func routeToHome() {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        loginViewController.modalPresentationStyle = .fullScreen
        show(loginViewController, sender: nil)
    }
}
