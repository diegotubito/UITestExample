//
//  LoginViewController.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import UIKit

class LoginViewController: BaseViewController<LoginAnalytics>, Storyboarded {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    
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
    
    override var analyticPlatform: AnalyticPlatforms {
        return .All
    }
    
    override func analyticsInit() {
        analytics = LoginAnalytics()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonOutlet.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        viewModel = LoginViewModel()
        viewModelBind()
    
    }
    
    @objc func buttonTapped() {
        analytics.customEvent(platform: .All)
        viewModel.login(userName: userName.text ?? "", password: password.text ?? "")
        
    }
    
    private func viewModelBind() {
        
        viewModel.onSuccess = { [weak self] model in
            DispatchQueue.main.async {
                self?.resultLabel.text = model.user.displayName
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.resultLabel.text = message
            }
        }
    }

    private func routeToHome() {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        loginViewController.modalPresentationStyle = .fullScreen
        show(loginViewController, sender: nil)
    }
}
