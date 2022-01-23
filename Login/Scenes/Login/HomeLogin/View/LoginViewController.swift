//
//  LoginViewController.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import UIKit

class LoginViewControllerAnalytics: BaseAnalytic {
    func someCustomEventFromLogin() {
        event(params: ["somekey":"some value"])
    }
}

class LoginViewController: BaseViewController<LoginViewControllerAnalytics>, Storyboarded {
    
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
    
    override func initAnalytics() {
        analytics = LoginViewControllerAnalytics()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = LoginViewModel()
        viewModelBind()
        
        analytics.someCustomEventFromLogin()
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





class BaseViewController<TAnalytic>: UIViewController where TAnalytic: BaseAnalyticProtocol {
    var analytics: TAnalytic!
    
    private var identifier: String {
        return String(describing: type(of: self))
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        initAnalytics()
        analytics.trackScreen()
    }
    
    internal func initAnalytics() {
        fatalError("Must override and init Analytics on \(identifier)")
    }
}









protocol BaseAnalyticProtocol: AnyObject {
    func trackScreen()
    func event(params: [String: Any])
}

class BaseAnalytic: BaseAnalyticProtocol {
    private var analyticsRepository: AnalyticsRepositoryProtocol
    
    private var identifier: String {
        return String(describing: type(of: self))
    }
    
    init(analyticsRepository: AnalyticsRepositoryProtocol = AnalyticsRepository()) {
        self.analyticsRepository = analyticsRepository
    }
    
    /* Conforming protocol BaseAnalyticProtocol */
    func event(params: [String: Any]) {
        
    }
    
    func trackScreen() {
        analyticsRepository.trackScreen(name: "name") {
           print("screen", "\(identifier)")
        }
    }
}







protocol AnalyticsRepositoryProtocol {
    func trackScreen(name: String, completion: () -> ())
}

class AnalyticsRepository: AnalyticsRepositoryProtocol {
    var firebase: AnalyticsRepositoryFirebaseProtocol
    
    init(_ firebase: AnalyticsRepositoryFirebaseProtocol = AnalyticsRepositoryFirebase() ) {
        self.firebase = firebase
    }
    
    
    func trackScreen(name: String, completion: () -> ()) {
        firebase.trackScreen(name: "", parameters: [:])
        completion()
    }
}



// include firebase analytics sdk and uncomment code
//import FirebaseAnalytics

protocol AnalyticsRepositoryFirebaseProtocol: AnyObject {
    func trackScreen(name: String, parameters: [String: Any])
    func trackEvent(event: String, parameters: [String: Any])
    func setUserID(userId: String)
}

class AnalyticsRepositoryFirebase: AnalyticsRepositoryFirebaseProtocol {
    
    func trackScreen(name: String, parameters: [String: Any]) {
        var params = parameters
//        params[AnalyticsParameterScreenName] = name
//        trackEvent(event: AnalyticsEventScreenView, parameters: params)
    }
    
    func trackEvent(event: String, parameters: [String: Any]) {
//        Analytics.logEvent(event, parameters: parameters)
    }
    
    func setUserID(userId: String) {
//        Analytics.setUserID(userId)
    }
}
