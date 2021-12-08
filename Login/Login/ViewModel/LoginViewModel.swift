//
//  LoginViewModel.swift
//  Login
//
//  Created by David Diego Gomez on 07/12/2021.
//

import Foundation

protocol LoginViewModelProtocol {
    init(withView view: LoginViewProtocol, service: ApiServiceProtocol)
    func login(userName: String, password: String)
}

protocol LoginViewProtocol {
    func showSuccess(_ user: User)
    func showError(message: String)
}

class LoginViewModel: LoginViewModelProtocol {
    var view: LoginViewProtocol
    var service: ApiServiceProtocol
    var model: LoginModel
    
    required init(withView view: LoginViewProtocol, service: ApiServiceProtocol) {
        self.view = view
        self.service = service
        self.model = LoginModel()
    }
    
    func login(userName: String, password: String) {
        
        let request = Request.endpoint(to: .Login(userName: userName, password: password))
        service.fetch(request: request, completionBlock: {response in
            switch response {
            case .success(let data):
                
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    self.view.showError(message: "Could Not Decode")
                    return
                }
                
                self.model.user = user
                self.view.showSuccess(user)
                break
            case .failure(let error):
                self.view.showError(message: error.message())
                print(error)
                break
            }
        })
    }
}
